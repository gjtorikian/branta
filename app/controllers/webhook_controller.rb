class WebhookController < ApplicationController
  def index
  end

  def create
    respond_to do |format|
      repo_name = params[:name]

      config = {
        :url => "#{request.protocol}#{request.host_with_port}#{post_receive_path}",
        :content_type => 'json'
      }
      options = {
        :events => ['page_build'],
        :active => true
      }

      begin
        result = JSON.parse create_hook(repo_name, config, options)
        owner, name = repo_name.split('/')
        Repository.new(owner: owner, name: name, name_with_owner: repo_name, hook_id: result['id']).save!
      rescue Octokit::UnprocessableEntity => e
        # TODO: hook already exists
      end

      format.json  { head :no_content }
    end
  end

  def delete
    respond_to do |format|
      repo_name = params[:name]

      page_repository = Repository.find_by_name_with_owner(repo_name)

      remove_hook(repo_name, page_repository.hook_id)

      page_repository.destroy

      format.json  { head :no_content }
    end
  end


  private

    def create_hook(repo_name, config, options)
      github_user.api.create_hook(repo_name, "web", config, options)
    end

    def remove_hook(repo_name, id)
      github_user.api.remove_hook(repo_name, id)
    end

    def pages_repository_params
      params.required(:pages_repository).permit(:name_with_owner, :hook_id)
    end
end

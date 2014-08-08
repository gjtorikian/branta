class WebhookController < ApplicationController
  def create
    respond_to do |format|
      repo_name = params[:name]

      config = {
        :url => "http://0.0.0.0/index",
        :content_type => 'json'
      }
      options = {
        :events => ['page_build'],
        :active => true
      }
      result = current_user.client.create_hook(repo_name, "web", config, options)

      PagesRepository.new(name_with_owner: repo_name, hook_id: result.id).save!

      format.json  { head :no_content }
    end
  end

  def delete
    respond_to do |format|
      repo_name = params[:name]

      page_repository = PagesRepository.find_by_name_with_owner(repo_name)

      current_user.client.remove_hook(repo_name, page_repository.hook_id)

      page_repository.destroy

      format.json  { head :no_content }
    end
  end


  private

    def pages_repository_params
      params.required(:pages_repository).permit(:name_with_owner, :hook_id)
    end
end

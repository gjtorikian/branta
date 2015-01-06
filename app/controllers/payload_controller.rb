class PayloadController < ApplicationController

  include PayloadValidations

  before_filter :verify_incoming_webhook_address!
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    event    = request.headers['HTTP_X_GITHUB_EVENT']
    delivery = request.headers['HTTP_X_GITHUB_DELIVERY']

    if valid_events.include?(event)
      request.body.rewind
      data =  JSON.parse request.body.read

      unless data["build"]["status"] == "built"
        redirect_to :status => 406, :json => "{}" and return;
      end

      if ENV['GITHUB_BRANTA_ORG_NAME'] && data['repository']['owner']['login'] != ENV['GITHUB_BRANTA_ORG_NAME']
        redirect_to :status => 406, :json => "{}" and return;
      end

      name  = data['repository']['name']
      owner = data['repository']['owner']['login']
      repository = Repository.where( \
            :name => name,
            :owner => owner,
            :name_with_owner => "#{name}/#{owner}",
            :hook_id => data['id'],
            :repo_id => data['repository']['id']).first_or_create

      if repository.active?
        repository.save!
        Resque.enqueue(Branta::Jobs::Index, event, data, repository)
        render :status => 201, :json => "{}"
      else
        Rails.logger.error "Repository is not configured to deploy: #{data['repository']}"
      end
    else
      render :status => 404, :json => "{}"
    end
  end

  def valid_events
    %w(page_build)
  end
end

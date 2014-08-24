class WebhookController < ApplicationController
  include WebhookValidations

  before_filter :verify_incoming_webhook_address!

  def create
    event    = request.headers['HTTP_X_GITHUB_EVENT']
    delivery = request.headers['HTTP_X_GITHUB_DELIVERY']

    if valid_events.include?(event)
      request.body.rewind
      data =  JSON.parse request.body.read

      unless data["build"]["status"] == "built"
        redirect_to :status => 406, :json => "{}" and return;
      end

      if ENV['GITHUB_BRANTA_ORG_NAME'] && data["repository"]["owner"]["login"] != ENV['GITHUB_BRANTA_ORG_NAME']
        redirect_to :status => 406, :json => "{}" and return;
      end

      Resque.enqueue(Receiver, event, delivery, data)
      render :status => 201, :json => "{}"
    else
      render :status => 404, :json => "{}"
    end
  end

  def valid_events
    %w(page_build)
  end
end

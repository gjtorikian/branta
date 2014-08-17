class WebhookController < ApplicationController
  include WebhookValidations

  before_filter :verify_incoming_webhook_address!
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    event    = request.headers['HTTP_X_GITHUB_EVENT']
    delivery = request.headers['HTTP_X_GITHUB_DELIVERY']

    if valid_events.include?(event)
      request.body.rewind
      data = request.body.read

      unless data["build"]["status"] == "built"
        render :status => 406, :json => "{}"
      end

      Resque.enqueue(Receiver, event, delivery, data)
      render :status => 200, :json => "{}"
    else
      render :status => 404, :json => "{}"
    end
  end

  def valid_events
    %w(page_build)
  end
end

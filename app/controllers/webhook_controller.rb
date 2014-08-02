class WebhookController < ApplicationController
  def create
    respond_to do |format|
      config = {
        :url => "http://0.0.0.0/index",
        :content_type => 'json'
      }
      options = {
        :events => ['page_build'],
        :active => true
      }
      current_user.client.create_hook(params[:name], "web", config, options)
      format.json  { head :no_content }
    end
  end
end

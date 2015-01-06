class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  end

  def default_url_options
    if Rails.env.development?
      { :host => "0.0.0.0", :port => 5000 }
    else
      { :host => "branta.io", :port => 443 }
    end
  end
end

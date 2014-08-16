require 'octokit'

class ApplicationController < ActionController::Base
  before_filter :save_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def basic_auth!
    unless basic_authenticated?
      render :status => :forbidden, :text => "Not authorized"
    end
  end

  def basic_authenticated?
    authenticate_with_http_basic do |u, p|
      return false unless u == 'heaven'

      Rack::Utils.secure_compare(ENV["BASIC_AUTH_PASSWORD"], p) ||
      Rack::Utils.secure_compare(ENV["BASIC_AUTH_ALT_PASSWORD"], p)
    end
  end

  def save_user
    if request.env["warden"] && github_user
      user = User.where(:github_id => github_user.id).first_or_initialize
      user.token = github_user.token
      user.github_id = github_user.id
      user.login = github_user.login
      user.save
    end
  end
end

class ResqueWhitelistConstraint
  def initialize
    @whitelisted_users = %w(gjtorikian)
  end

  def matches?(request)
    return false unless user = request.env['warden'].user(:user)
    @whitelisted_users.include? user.login
  end
end

Branta::Application.routes.draw do
  root 'application#index'

  post "/post_receive"         => "webhook#create"
  get "/search"                => "search#index"

  if ENV['GITHUB_BRANTA_ORG_NAME'].nil?
    get "/login"               => "sessions#create"
    get "/logout"              => "sessions#destroy"

    mount Resque::Server.new, :at => "/resque", constraints: ResqueWhitelistConstraint.new
  else
    github_authenticate(:org => ENV['GITHUB_BRANTA_ORG_NAME']) do
      get "/login"               => "sessions#create"
      get "/logout"              => "sessions#destroy"

      mount Resque::Server.new, :at => "/resque"
    end
  end
end

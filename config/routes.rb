Branta::Application.routes.draw do
  root 'application#index'

  get "/login"               => "sessions#create"
  get "/logout"              => "sessions#destroy"

  # Callbacks from webhooks
  post "/post_receive"         => "webhook#create"

  get "/search"                => "search#index"

  # github_authenticate(:org => 'github') do
    mount Resque::Server.new, :at => "/resque"
  # end
end

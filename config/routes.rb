Branta::Application.routes.draw do
  get "/"                    => "application#index"
  mount Resque::Server.new, :at => "/resque"

  github_authenticate(:team => :employees) do
    get "/login"               => "sessions#create", :as => :login
  end

  get "/logout"                => "sessions#destroy"

  # Callbacks from webhooks
  post "/post_receive"          => "webhook#create"

  # You can have the root of your site routed with "root"
  root 'site#index'
end

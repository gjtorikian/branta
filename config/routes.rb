Branta::Application.routes.draw do
  get "/"                    => "application#index"

  github_authenticate(:team => :employees) do
    get "/login"               => "sessions#create", :as => :login
  end

  get "/logout"                => "sessions#destroy"

  # You can have the root of your site routed with "root"
  root 'site#index'


  # Callbacks from .com Web Hooks
  # post "/postreceive"          => "github_callbacks#handler"
end

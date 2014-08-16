Rails.application.routes.draw do
  get 'site/index'

  post 'webhook/create'
  delete 'webhook/delete'

  # You can have the root of your site routed with "root"
  root 'site#index'

  devise_for :users, controllers: { :omniauth_callbacks => "users/omniauth_callbacks", registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}, skip: [:sessions, :registrations]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_scope :user do
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    get    "signout" => 'devise/sessions#destroy',    as: :destroy_user_session

    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

end

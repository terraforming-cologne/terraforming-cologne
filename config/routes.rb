Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Tournament

  resources :tournaments, only: [:index, :new, :create, :edit, :update] do
    resources :participations, shallow: true
  end
  resources :payments, only: [:new, :create]

  get :register, to: "registrations#new"

  # User

  resource :account, only: [:show, :edit, :create, :update, :destroy]
  resource :locale, only: [:update]
  resource :login, only: [:create]
  resource :password, only: [:edit, :update]
  resources :password_resets, only: [:new, :edit, :create, :update], param: :token
  resource :profile, only: [:show]

  get :signup, to: "accounts#new"
  get :login, to: "logins#new"
  delete :logout, to: "logins#destroy"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  # Defines the root path route ("/")
  root "static_pages#home"
end

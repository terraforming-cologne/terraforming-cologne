Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resolve("Tally") { [:game, :tally] }
  resolve("FirstRound") { [:tournament, :first_round] }
  resolve("NextRound") { [:tournament, :next_round] }

  resource :timer, only: :show

  shallow do
    # Tournament
    resources :tournaments, only: [:index, :show, :new, :create, :edit, :update] do
      resources :attendances, only: :create
      resources :tables, only: :index
      resource :tally, only: [:new, :create]

      resource :ranking, only: :show

      resources :participations do
        resource :payment, only: :create
      end

      resources :games, only: [] do
        resource :tally, only: [:new, :create, :edit, :update]
      end

      # Administration
      resource :bridge, only: :show

      resource :first_round, only: [:new, :create]
      resource :next_round, only: [:new, :create]

      resources :reseats, only: [:new, :create]

      # Shortcuts
      get :register, to: "registrations#new"
    end

    # User
    resource :account, only: [:show, :edit, :create, :update, :destroy]
    resource :locale, only: :update
    resource :login, only: :create
    resource :password, only: [:edit, :update]
    resources :password_resets, only: [:new, :edit, :create, :update], param: :token
    resource :profile, only: :show
  end

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
  root "static_pages#index"
end

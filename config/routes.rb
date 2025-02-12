Rails.application.routes.draw do

  get 'virus_total', to: 'virus_total#index'
  post 'virus_total/scan', to: 'virus_total#scan'
  get 'virus_total/scan', to: 'virus_total#scan'
  
  get 'virus_total/:id/behavior', to: 'virus_total#get_behavior_analysis', as: 'behavior_analysis'
  

  resources :scans, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create]
  end
  
  resources :comments, only: [:index, :edit, :update, :destroy] do
    member do
      post 'vote'
    end
  end

  resources :scans do
    member do
      post 'upvote'
      post 'downvote'
    end
  end
  
  resources :virus_total do
    collection do
      post 'scan'
      get 'scan'
    end
  end
  
  get "/about",to: "about#index", as: :about
  get 'dashboard', to: 'dashboard#index'
  
  resource :registration
  resource :session
  resource :password_reset
  resource :password

  resource :preferences, only: [:edit, :update]

  resource :dashboard

  get '/auth/auth0/callback', to: 'auth0#callback'
  get '/auth/failure', to: 'auht0#failure'
  get '/auth/logout', to: 'auht0#logout'
  
  root to: "main#index"

  post 'toggle_dark_mode', to: 'dark_mode#toggle'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end

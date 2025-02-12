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

  get "up" => "rails/health#show", as: :rails_health_check

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end

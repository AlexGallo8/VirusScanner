Rails.application.routes.draw do

  get 'virus_total', to: 'virus_total#index'
  post 'virus_total/scan', to: 'virus_total#scan'
  get 'virus_total/scan', to: 'virus_total#scan'
  

  resources :scans, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :comments, only: [:index, :show, :new, :create, :edit, :update, :destroy]
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

  get 'virus_total/pick_from_drive'
  post 'virus_total/download_from_drive', to: 'virus_total#download_from_drive'

  root to: "main#index"

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

end

Rails.application.routes.draw do

  get 'virus_total', to: 'virus_total#index'
  post 'virus_total/scan', to: 'virus_total#scan'
  

  resources :scans, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  #delete "sign_out", to: "sessions#destroy", as: :sign_out
  get "/about",to: "about#index", as: :about
  
  post '/local_login', to: 'sessions#local_login'
  post '/local_signup', to: 'sessions#local_signup'
  delete '/logout', to: 'sessions#destroy'

  get 'dashboard', to: 'dashboard#index'



  root to: "main#index"

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

end

Rails.application.routes.draw do

  get 'virus_total', to: 'virus_total#index'
  post 'virus_total/scan', to: 'virus_total#scan'
  

  resources :scans, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  delete "sign_out", to: "sessions#destroy", as: :sign_out
  get "/about",to: "about#index", as: :about
  get "sign_up", to: "registrations#new", as: :sign_up
  post "sign_up", to: "registrations#create"
  
  get "sign_in", to: "sessions#new", as: :sign_in
  post "sign_in", to: "sessions#create"

  root to: "main#index"

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

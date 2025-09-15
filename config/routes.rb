Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  
  # RESTful routes for projects and tasks
  resources :projects do
    resources :tasks, except: [:index]  # Tasks are nested under projects
  end
  
  resources :tasks, only: [:index]  # Global task index for users to see their tasks
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :users,         only: %i[ index new create ] do
    resource :backlog,      only: %i[ show ] do
      post "add_game/:game_id", to: "backlogs#add_game", as: "add_game"
      delete "remove_game/:game_id", to: "backlogs#remove_game", as: "remove_game"
    end
    get "stats", to: "user_stats#show"
  end
  resources :user_sessions, only: %i[ new create destroy ]
  resources :games,         only: %i[ index show ] do
    resources :ratings,       only: %i[ create update destroy ]
    resource  :favorites,     only: %i[ create destroy ]
  end
  resources :companies,     only: %i[ index show ]
  get "search", to: "search#index"

  # Defines the root path route ("/")
  root "games#index"
end

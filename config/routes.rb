Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      # Auth routes
      post '/auth/login', to: 'auth#login'
      delete '/auth/logout', to: 'auth#logout'

      # User routes
      resources :users, only: [:index, :show, :create, :update, :destroy]

      # Dashboard (protected example endpoint)
      get '/dashboard', to: 'dashboard#index'

      # Feature flags
      resources :features, only: [:index, :show]

      # Health check endpoint
      get '/health', to: 'health#index'
    end
  end

  # Mount Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Mount Sidekiq UI and Flipper UI in development
  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'

    mount Flipper::UI.app(Flipper) => '/flipper'
  end
end

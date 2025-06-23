# config/routes.rb
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "categories#index"

  # Authentication routes
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "users#new", as: :new_user_registration
  post "/signup", to: "users#create"

  # User management routes
  resources :users, only: [:edit, :update, :destroy]

  # For search functionality
  get '/search', to: 'menu_items#search'

  # For filtering by category
  get '/menu/:category_slug', to: 'categories#show'

  # For user profile management
  resource :profile, only: [:show, :edit, :update]

  # For contact/about pages
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  resources :categories do
    resources :menu_items, only: [:index]
  end

  resources :menu_items do
    resources :customizations, except: [:show]
  end

  resources :orders do
    member do
      get :checkout
      patch :complete
      post :add_loyalty_punch  # Fixed: proper route for loyalty punches
    end

    collection do
      get :current
    end
  end
  
  # Order items routes (for AJAX cart operations)
  resources :order_items, only: [:create, :update, :destroy]

  # Receipt upload system
  resources :receipt_uploads, only: [:index, :show, :create, :destroy]

  # Loyalty card routes (simplified - removed problematic punch action)
  resources :loyalty_cards, only: [:index, :show, :create] do
    member do
      patch :redeem
    end
    
    collection do
      get :current_card
    end
  end

  # Restaurant info routes
  resource :restaurant_info, only: [:show, :edit, :update]

  # Admin routes - comprehensive admin panel
  namespace :admin do
    # Admin dashboard
    root 'dashboard#index'
    get 'dashboard', to: 'dashboard#index'
    
    # Core content management
    resources :categories
    resources :menu_items do
      resources :customizations
    end
    
    # Order management
    resources :orders, only: [:index, :show, :update]
    
    # User management
    resources :users do
      member do
        patch :toggle_admin
      end
    end
    
    # Receipt upload management
    resources :receipt_uploads do
      member do
        patch :approve
        patch :reject
      end
    end
    
      # Password reset routes

    resources :password_resets, only: [:new, :create]
    get 'password_resets/:id/edit', to: 'password_resets#edit', as: :edit_password_reset
    patch 'password_resets/:id', to: 'password_resets#update', as: :password_reset


    # Loyalty system management
    resources :loyalty_cards, only: [:index, :show]
    resources :loyalty_punches, only: [:index, :show, :destroy]
    
    # Banner photo management
    resources :banner_photos, except: [:show]
    
    # Restaurant info
    resource :restaurant_info
  end

  # API routes (if you plan to add mobile app or API access)
  namespace :api do
    namespace :v1 do
      resources :categories, only: [:index, :show]
      resources :menu_items, only: [:index, :show]
      
      resources :orders, only: [:create, :show, :update] do
        member do
          post :add_loyalty_punch
        end
      end
      
      resources :order_items, only: [:create, :update, :destroy]
      resources :receipt_uploads, only: [:index, :show, :create]
      
      resources :loyalty_cards, only: [:index, :show, :create] do
        member do
          patch :redeem
        end
        
        collection do
          get :current_card
        end
      end
    end
  end
end
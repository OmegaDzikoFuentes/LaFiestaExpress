Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "categories#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

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
    end

    collection do
      get :current
    end
  end
 # Order items routes (for AJAX cart operations)
 resources :order_items, only: [:create, :update, :destroy]

 # Restaurant info routes
 resource :restaurant_info, only: [:show, :edit, :update]

 # Admin routes (optional - for organized admin access)
 namespace :admin do
   resources :categories
   resources :menu_items do
     resources :customizations
   end
   resources :orders, only: [:index, :show, :update]
   resource :restaurant_info
 end

 # API routes (if you plan to add mobile app or API access)
 namespace :api do
   namespace :v1 do
     resources :categories, only: [:index, :show]
     resources :menu_items, only: [:index, :show]
     resources :orders, only: [:create, :show, :update]
     resources :order_items, only: [:create, :update, :destroy]
   end

end
end

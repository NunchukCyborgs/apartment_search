Rails.application.routes.draw do
  resources :reviews
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { passwords: 'devise/passwords', registrations: 'devise/registrations', confirmations: 'devise/confirmations' }

  mount Maily::Engine, at: 'maily'
  resources :user_sessions
  post '/users/licensing', to: 'licensing#authenticate', format: :json
  post '/users/properties', to: 'properties#user', format: :json
  get '/licenses/:license_id', to: 'licensing#show', format: :json
  post 'licenses/:license_id/contacts', to: 'contacts#create_with_license', format: :json
  get '/me', to: 'users#me', format: :json
  resources :users

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout

  resources :payments, only: [:create, :index, :destroy] do
    collection do
      get 'fees'
      post 'requests', to: 'payments#request_payment'
      patch 'requests/:token', to: 'payments#update_request'
    end
  end
  resources :contacts, only: [:create, :update, :show], format: :json
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  post "/properties/facets" => "properties#facets"
  post "/properties/filtered_results" => "properties#filtered_results"
  get "/properties/facets" => "properties#facets"
  get "/properties/filtered_results" => "properties#filtered_results"

  resources :properties, only: [:show, :update, :index], defaults: { format: :json } do
    collection do
      get 'search'
      post 'request', to: 'properties#request_property'
    end
    member do
      delete 'images/:image_id', to: 'properties#delete_image'
    end
  end

  post '/properties/:id/images', to: 'properties#images', format: :html

  #get "/properties/:id" => "properties#show"
  #patch "/properties/:id" => "properties#update"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

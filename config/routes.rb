Gift::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match '/invites/friends.json' => 'invites#create_facebook', :via => :post
  match '/projects/:project_id/invites/facebook/accept/:id' => 'invites#facebook_update', :via => :get, :as => :project_invite_facebook_update
  match '/projects/:project_id/invites/facebook/ignore/:id' => 'invites#facebook_destroy', :via => :get, :as => :project_invite_facebook_destroy

  match '/attachments/(:id)' => 'attachments#update', :as => :attachment, :via=>:put

  resources :projects do
    resources :withdraws do
      get 'paypal'  => 'withdraw#paypal', :on => :collection
      get 'paypal'  => 'withdraw#paypal', :on => :collection      
    end
    post :close
    resources :invites
    resources :fees do
      member do
        get :paypal
      end
    end
    resources :comments
    resources :cards do
      resource :votes
      post :amazon_search, on: :collection
      post :amazon_lookup, on: :collection
    end
  end

  mount ImagesFetcher::Engine, at: '/im'

  devise_for :users,
             controllers: {omniauth_callbacks: "omniauth_callbacks", registrations: "users/registrations"}

  resource :user, only: [:show]

  authenticate :user do
    root to: 'projects#index'
  end

  devise_scope :user do
    match '/update_token' => 'users#update_token', :as => :update_token, :via => :post
    match 'users/profile' => 'users/registrations#profile', :as => :profile, :via => :put
  end

  match '/facebook' => 'users#facebook_invite'


  root to: 'users#show'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

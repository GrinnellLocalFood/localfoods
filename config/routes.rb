Localfoods::Application.routes.draw do

  resources :users do
    member do
      get 'editpassword'
    end

    member do
      put 'updatepassword'
    end

    member do
      get 'edit'
    end

  end

  resources :items do
    member do
      get 'show'
    end

    member do
      get 'edit'
    end

    member do
      put 'update'
    end
  end


# How to make a link to a path like /inventories/:id/foo:
# 
# inventory = Inventory.find(1)
# link_to inventory(foo) will produce localhost/inventories/1/foo

  resources :inventories do
    member do
      get 'edit'
    end

    member do
      get 'public_index'
    end
    
  end

  resources :sessions, :only => [:new, :create, :destroy]

  resources :application_states

  match '/register',  :to => 'users#new'
  match '/login',  :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  match '/producer_newitem', :to => 'items#producer_new'
  match '/admin_coord_newitem', :to => 'items#admin_coord_new'
  match '/editorderstate', :to => 'application_states#editorderstate' 

  resources :password_resets

  root :to => 'pages#home'


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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

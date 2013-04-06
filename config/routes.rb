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


# How to make a link to a path like /inventories/:id/foo:
#
# inventory = Inventory.find(1)
# link_to inventory(foo) will produce localhost/inventories/1/foo

  resources :inventories do
    member do
        get 'show_in_index'
      end

    member do
      get 'add'
    end

    resources :items do
      collection do
        get 'producer_new'
      end

      member do
        get 'show_in_modal'
      end

    end

  end
  resources :purchases, :only => [:new, :create, :index]
  resources :cart_items
  resources :cart do
    member do
      get 'show_in_modal'
    end
  end



  controller :items do
    post 'items' => 'items#search'
    get 'items' => 'items#search'
  end

  resources :sessions, :only => [:new, :create, :destroy]
  
  resources :application_states
 
 
  match '/register', :to => 'users#new'
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  match '/admin_coord_newitem', :to => 'items#admin_coord_new'
  match '/admin_coord_createitem', :to => 'items#admin_create'
  match '/editorderstate', :to => 'application_states#editorderstate'
  match '/all_orders', :to => 'purchases#all_orders'
  match '/process_order', :to => 'purchases#process_order'
  match '/about', :to => 'pages#about'
  match '/pickup_info', :to => 'pages#pickup_info'
  match '/acknowledgements', :to => 'pages#acknowledgements'


  resources :password_resets
  resources :inventory_photos, :only => [:destroy]

  resources :categories do
    member do
      get 'show_by_category'
    end

    collection do
      get 'show_all'
    end
  end

  root :to => 'pages#home'




  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # resources :products

  # Sample resource route with options:
  # resources :products do
  # member do
  # get 'short'
  # post 'toggle'
  # end
  #
  # collection do
  # get 'sold'
  # end
  # end

  # Sample resource route with sub-resources:
  # resources :products do
  # resources :comments, :sales
  # resource :seller
  # end

  # Sample resource route with more complex sub-resources
  # resources :products do
  # resources :comments
  # resources :sales do
  # get 'recent', :on => :collection
  # end
  # end

  # Sample resource route within a namespace:
  # namespace :admin do
  # # Directs /admin/products/* to Admin::ProductsController
  # # (app/controllers/admin/products_controller.rb)
  # resources :products
  # end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
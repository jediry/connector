Connector::Application.routes.draw do
  root :to => 'users#home'

  resources :groups
  match '/groups/:group_id/members', :to => 'groups#add_member', :via => :post
  match '/groups/:group_id/members/:person_id', :to => 'groups#update_member', :via => :put
  match '/groups/:group_id/members/:person_id', :to => 'groups#remove_member', :via => :delete

  resources :regions

  resources :messages, :except => :show

  resources :people
  match '/people/:person_id/groups', :to => 'people#add_to_group', :via => :post
  match '/people/:person_id/groups/:group_id', :to => 'people#remove_from_group', :via => :delete

  resources :tasks
  match '/tasks/:task_id/notes', :to => 'tasks#add_note', :via => :post

  resources :task_types do
    resources :sub_task_types
  end

  resources :users do
    member do
      get 'password'
      post 'reset_password'
    end
  end
  match '/home', :to => 'users#home'
  match '/todo', :to => 'users#todo', :via => :get
  match '/email_overdue', :to => 'tasks#overdue', :via => :get

  resources :sessions, :only => [ :new, :create, :destroy ]
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  #match '/logout', :to => 'sessions#destroy', :via => :delete

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

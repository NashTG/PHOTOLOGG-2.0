Rails.application.routes.draw do
  get 'sessions/new'

  get 'amistad/add'

  get 'amistad/show'

  get 'amistad/destroy'

#  get '/comentar' => 'comentario/add'
  #post 'comentar' => 'comentario/add'

  #get 'comentario' => 'comentario/show'
  #get 'comentar' => 'comentario/add'

  get 'comentario/destroy'

  get 'registro' => 'usuario#add'

  post 'registro' => 'usuario#create'

  get 'usuario/show'
  get 'editar' => 'usuario#editar'
  patch 'editar' => 'usuario#show'
  post 'usuarios' => 'usuario#show'
  get 'usuario/destroy'
  get 'auditoria' => 'usuario#auditoria'

  get "fotos" => "foto#index"
  post "fotos" => "foto#show"
  post "foto/create"

  get 'foto/show'
  get 'listar_cuentas' => 'usuario#index'

  get 'foto/destroy'
  #get 'auditoria' => 'auditoria#index'

  get 'subir' => 'foto#add'

  get    'login'   => 'sessions#new'

  post   'login'   => 'sessions#create'
  get 'index' => 'foto#index'

  get 'logout'  => 'sessions#destroy'
 

  resources :usuario
  resources :foto do
    resources :comentario
  end

  resources :amistad
  resources :auditoria
  resources :home
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#home'

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

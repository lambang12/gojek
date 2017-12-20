Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  controller :users do
    get 'user' => :index
    get 'user/edit' => :edit
    patch 'user' => :update
    delete 'user' => :destroy
  end

  resources :orders

  controller :session do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :gopay do
    get 'topup' => :topup
    post 'topup' => :set_topup
  end
  
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      controller :orders do
        post 'allocate' => :allocate
      end
      controller :users do
        post 'check_user' => :check_if_exists
      end
    end
  end
  
  root 'dashboard#index', as: 'index'
end
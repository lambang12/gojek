Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  controller :users do
    get 'user' => :index
    get 'user/edit' => :edit
    patch 'user' => :update
    delete 'user' => :destroy
  end

  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  controller :session do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :gopay do
    # get 'gopay/register' => :new
    # post 'gopay/register' => :create
    get 'topup' => :topup
    post 'topup' => :set_topup
  end
  
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :orders
    end
  end
  root 'dashboard#index', as: 'index'
end
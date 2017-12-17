Rails.application.routes.draw do
  # resources :users, except: [:edit, :update, :show]
  controller :users do
    get 'user' => :index
    get 'register' => :new
    post 'register' => :create
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
    get 'gopay/register' => :new
    post 'gopay/register' => :create
  end

  root 'dashboard#index', as: 'index'
end
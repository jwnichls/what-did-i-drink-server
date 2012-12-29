WhatdididrinkApi::Application.routes.draw do

  # Resources
  resources :authentications, :only => [:index,:create,:destroy] do
    collection do 
      get :logout
    end
  end

  resources :users, :only => [:index,:show,:edit,:update]
  
  resources :drinks do
    # member do
    #  post :checkin
    # end
    
    # resources :wish, :only => [:create] do
    #   collection do
    #     delete :destroy
    #   end
    # end
  end

  # Checkin Routes
  resources :checkins, :only => [:index,:new,:create,:show]

  # Wishlist Routes
  resources :wishes, :only => [:index,:create, :destroy]
  match 'wishlist' => 'wishes#index', :as => :wishlist

  # Authentication URLs for Omniauth
  match '/auth/:provider/callback' => 'authentications#create'

  # A global logout path
  match 'logout' => 'front#logout', :as => :logout

  # Hopefully map all of the front UI actions
  resources :front, :only => [:index] do
    collection do
      get :main
      get :finddrink
      get :logout
    end
  end

  # Map the root
  root :to => 'front#index'
end

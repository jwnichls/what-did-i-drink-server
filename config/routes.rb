WhatdididrinkApi::Application.routes.draw do

  #******************
  # API
  #******************

  constraints :subdomain => "api" do
    namespace :v1, defaults: {format: 'json'} do
      resources :drinks, :only => [:index,:create,:show,:update,:destroy] do
        collection do
          post :search
        end
      end
    end
  end

  #******************
  # Web UI
  #******************

  # Resources
  resources :authentications, :only => [:index,:create,:destroy] do
    collection do 
      get :logout
    end
  end

  resources :users, :only => [:index,:show,:edit,:update]
  
  resources :drinks do
    collection do
      get :autocomplete_drink_name
      get :autocomplete_drink_created_by
      post :search
    end

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
  match 'checkin' => 'checkins#create', :as => :checkin

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
      get :logout
    end
  end

  # Map the root
  root :to => 'front#index'
end

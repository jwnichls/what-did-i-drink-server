require 'api_constraints'

WhatdididrinkApi::Application.routes.draw do

  #******************
  # API
  #******************

  constraints :subdomain => "api" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true), defaults: {format: 'json'} do
      resources :drinks, :only => [:index,:create,:show,:update,:destroy] do
        collection do
          post :search
        end
      end
      
      resources :checkins, :only => [:index,:create,:show]

      # Wishlist Routes
      resources :wishlist, :only => [:index,:create,:destroy]
      match '/wishlist' => 'wishlist#destroy', :via => :delete
      
      # need to add some kind of route to test users
      resources :users, :only => [:index,:show,:update]
    end
  end

  #******************
  # Web UI
  #******************

  # TEMP TEMP TEMP
  resources :temp_access_tokens, :only => [:index, :create]

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

  # Wishlist Routes
  resources :wishes, :only => [:index,:create, :destroy]

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

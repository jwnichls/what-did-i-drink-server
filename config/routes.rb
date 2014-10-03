require 'api_constraints'

WhatdididrinkApi::Application.routes.draw do

  use_doorkeeper

  #******************
  # API
  #******************

  constraints :subdomain => "api" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true), defaults: {format: 'json'} do
      resources :drinks, :only => [:index,:create,:show,:update,:destroy] do
        collection do
          post :search
          get :search
        end
      end
      
      resources :checkins, :only => [:index,:create,:show]

      # Wishlist Routes
      resources :wishlist, :only => [:index,:create,:destroy]
      match '/wishlist' => 'wishlist#destroy', :via => :delete
      
      # need to add some kind of route to test users
      resources :users, :only => [:index,:show,:update] do
        member do
          post :update_location
        end
      end
      
      # Timeline routes
      resources :timeline_entries, :only => [:index]
      match 'timeline' => 'timeline_entries#index', :as => :timeline
      
      # Venues Routes
      resources :venues do
        member do
          put :verify
        end
        collection do
          post :search
          get :search
        end
      end
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

  resources :users, :only => [:index,:show,:edit,:update] do
    member do
      post :update_location
    end
  end
  
  resources :drinks do
    collection do
      get :autocomplete_drink_name
      get :autocomplete_drink_created_by
      post :search
      get :search
      get :format
      get :listitems
    end
  end

  # Checkin Routes
  resources :checkins, :only => [:index,:new,:create,:show]

  # Images
  resources :images, :only => [:create, :show]

  # Wishlist Routes
  resources :wishes, :only => [:index,:create,:destroy]

  # Venues Routes
  resources :venues do
    member do
      put :verify
    end
    collection do
      get :autocomplete_venue_name
      get :listitems
      post :search
      get :search
    end
  end

  # Authentication URLs for Omniauth
  match '/auth/:provider/callback' => 'authentications#create'

  # username/password account creation routes
  resources :identities, :only => [:new]

  # A global logout path
  match 'logout' => 'front#logout', :as => :logout

  # oauth login path
  match 'login' => 'front#login', :as => :login

  resources :timeline_entries, :only => [:index]
  match 'timeline' => 'timeline_entries#index', :as => :timeline

  # Hopefully map all of the front UI actions
  resources :front, :only => [:index] do
    collection do
      get :login
      get :logout
    end
  end

  # Book web page
  match 'book' => 'front#book'

  # Map the root
  root :to => 'front#index'
end

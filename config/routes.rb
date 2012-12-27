WhatdididrinkApi::Application.routes.draw do

  # Resources
  resources :authentications, :only => [:index,:create,:destroy] do
    collection do 
      get :logout
    end
  end

  resources :wishlists
  resources :users
  resources :drinks

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

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged_in?
    session[:user] != nil
  end
  
  def login_user(user)
    puts "User: " + user.to_s
    
    session[:user] = user
  end
  
  def current_user
    session[:user]
  end
  
  def logout_user
    session[:user] = nil
  end
  
  def foursquare
    unless current_user.foursquare_access_token != nil and current_user.foursquare_access_token != ""
      puts "Creating generic Foursquare Access: " + ENV['FOURSQUARE_APP_ID'] + " " + ENV['FOURSQUARE_APP_SECRET']
      @foursquare ||= Foursquare::Base.new(ENV['FOURSQUARE_APP_ID'], ENV['FOURSQUARE_APP_SECRET'])
    else
      puts "Using User Specific Foursquare: " + current_user.foursquare_access_token
      @foursquare ||= current_user.foursquare
    end
  end
  
end

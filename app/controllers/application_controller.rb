class ApplicationController < ActionController::Base
  layout "application"
  helper_method :logged_in?, :current_user
  protect_from_forgery
  
  before_filter :adjust_format_for_mobile
  before_filter :set_timezone

  def set_timezone  
    min = request.cookies["time_zone"].to_i
    if min
      Time.zone = ActiveSupport::TimeZone[-min.minutes]
    end
  end
  
  def restrict_access
    head :unauthorized unless current_user
  end
  
  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id)
    end
  end
  
  def logged_in?
    session[:user_id] != nil
  end
  
  def login_user(user)
    session[:user_id] = user.id
  end
  
  def logout_user
    session[:user_id] = nil
  end
  
  def foursquare
    unless current_user != nil and current_user.foursquare_access_token != nil and current_user.foursquare_access_token != ""
      puts "Creating generic Foursquare Access: " + ENV['FOURSQUARE_APP_ID'] + " " + ENV['FOURSQUARE_APP_SECRET']
      @foursquare ||= Foursquare::Base.new(ENV['FOURSQUARE_APP_ID'], ENV['FOURSQUARE_APP_SECRET'])
    else
      puts "Using User Specific Foursquare: " + current_user.foursquare_access_token
      @foursquare ||= current_user.foursquare
    end
  end
  
  private

  # Set iPhone format if request to m.whatdididrink.com
  def adjust_format_for_mobile
    request.format = :mobile if mobile_request?
  end
  
  # Return true for requests to iphone.myserver.com
  def mobile_request?
    return (request.host.match(/^m\./) || params[:format] == "mobile")
  end

  def mobile_redirect?
    puts "Test: " + request.host + " : " + mobile_user_agent?.to_s + " : " + (session[:mobile_param] ? session[:mobile_param].to_s : "")
    
    if not request.host.match(/^m\./)
      if session[:mobile_param] != nil
        puts "mobile param not null!" + session[:mobile_param]
        session[:mobile_param] == "1"
      else
        puts "checking user agent!"
        mobile_user_agent?
      end
    else
      false
    end
  end

  def redirect_to_mobile(request)
    session[:mobile_param] = "1"
    
    redirect_to mobilize_request_url(request)
  end

  def redirect_to_desktop(request)
    session[:mobile_param] = "0"
    
    redirect_to demobilize_request_url(request)
  end

  # Request from a mobile browser
  def mobile_user_agent?
    # extend this to work with Android and whatever else
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/Mobile|webOS/]
  end

  def mobilize_request_url(request)    
    "http://" + (request.host.match(/^m\./) ? "" : "m.") + request.host.sub(/^www./,"") + (request.port != 80 ? ":" + request.port.to_s : "")  + request.path
  end
  
  def demobilize_request_url(request)
    "http://" + request.host.sub(/^m\./,"") + (request.port != 80 ? ":" + request.port.to_s : "") + request.path
  end
end

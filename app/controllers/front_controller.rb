class FrontController < ApplicationController
  layout "application"

  def index
    if mobile_redirect?
      redirect_to_mobile(request)
    else
      session[:redirect] = "/"

      if logged_in?
        @drinks = Drink.visible.order("name")
        @user = current_user
        
        render "users/show"
      else
        render "front/login"
      end
    end
  end

  def login
    respond_to do |format|
      format.html # login.html.erb
      format.mobile # login.mobile.erb
    end
  end
  
  def logout
    logout_user
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.mobile { redirect_to root_path }
      format.json { head :no_content }
    end
  end
end

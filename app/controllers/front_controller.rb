class FrontController < ApplicationController
  layout "application"

  def index
    if mobile_redirect?
      redirect_to_mobile(request)
    else
      session[:redirect] = "/"

      if logged_in?
        @drinks = Drink.all(:order => "name")
      end
      
      respond_to do |format|
        format.html # index.html.erb
        format.mobile # index.mobile.erb
      end
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

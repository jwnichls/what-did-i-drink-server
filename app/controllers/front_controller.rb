class FrontController < ApplicationController
  layout "application"
  before_filter :parse_user

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
  
  def finddrink
    if (params[:drink][:name] == "")
      redirect_to :controller => :drinks, :action => :index
    end
    
    @query = params[:drink][:name]
    @drinks = Drink.search(:all, :query => @query)
    
    if @drinks.length == 1 or (@drinks.length > 0 and @drinks[0].name == params[:drink][:name])
      redirect_to @drinks[0]
    else
      redirect_to :controller => :drinks, :action => :index, :query => @query
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

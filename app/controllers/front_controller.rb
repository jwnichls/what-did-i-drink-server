class FrontController < ApplicationController
  layout "application"
  before_filter :parse_user

  def index
    if mobile_redirect?
      redirect_to_mobile(request)
    elsif logged_in?
      redirect_to :action => :main
    else
      respond_to do |format|
        format.html # index.html.erb
        format.mobile # index.iphone.erb
      end
    end
  end

  def main
    if !logged_in?
      redirect_to :action => :index
    else    
      @drinks = Drink.all(:order => "name")
    
      respond_to do |format|
        format.html # index.html.erb
        format.mobile # index.iphone.erb
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
end

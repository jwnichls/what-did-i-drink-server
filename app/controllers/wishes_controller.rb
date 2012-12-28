class WishesController < ApplicationController
  # GET /wishlists
  # GET /wishlists.json
  def index
    @wishes = current_user.wishes

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wishes }
    end
  end
  
  def create
    puts "wish created called"
    
    @drink = Drink.find(params[:drink_id])
    current_user.addToWishList(@drink)

    @redirect = @drink
    if session[:redirect]
      @redirect = session[:redirect]
    end
    
    redirect_to @redirect
  end
  
  def destroy
    puts "wish destroy called"

    @drink = Drink.find(params[:drink_id])
    current_user.removeFromWishList(@drink)
    
    @redirect = @drink
    if session[:redirect]
      @redirect = session[:redirect]
    end
    
    redirect_to @redirect
  end  
end

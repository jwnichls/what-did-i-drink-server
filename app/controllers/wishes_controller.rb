class WishesController < ApplicationController
  before_filter :parse_user

  # GET /wishlists
  # GET /wishlists.json
  def index
    @wishes = current_user.wishes

    session[:redirect] = wishlist_path

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wishes }
    end
  end
  
  def create
    @drink = Drink.find(params[:drink_id])
    current_user.addToWishList(@drink)

    @redirect = @drink
    if session[:redirect]
      @redirect = session[:redirect]
    end
    
    redirect_to @redirect
  end
  
  def destroy
    if params[:drink_id]
      @drink = Drink.find(params[:drink_id])
    elsif params[:id]
      @drink = Wish.find(params[:id]).drink
    end
    
    current_user.removeFromWishList(@drink)
    
    @redirect = @drink
    if session[:redirect]
      @redirect = session[:redirect]
    end
    
    redirect_to @redirect
  end  
end

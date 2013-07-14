class WishesController < ApplicationController
  # GET /wishlists
  # GET /wishlists.json
  def index
    @wishes = current_user.wishes.paginate(:per_page => 20, :page => params[:page])

    session[:redirect] = wishes_path

    respond_to do |format|
      format.html # index.html.erb
      format.mobile
      format.json { render json: @wishes }
    end
  end
  
  def create
    @drink = Drink.find(params[:drink_id])
    current_user.add_to_wish_list(@drink)

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
      @drink = current_user.wishes.find(params[:id]).drink
    end
    
    current_user.remove_from_wish_list(@drink)
    
    @redirect = @drink
    if session[:redirect]
      @redirect = session[:redirect]
    end
    
    redirect_to @redirect
  end  
end

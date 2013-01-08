module V1
  class WishlistController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
    before_filter :restrict_access

    # GET /wishlist.json
    def index
      respond_with current_user.wishes
    end
  
    # POST /wishlist.json
    def create
      @drink = Drink.find(params[:drink_id])
      respond_with current_user.addToWishList(@drink)
    end

    # DELETE /wishlist.json?drink_id=
    def destroy
      if params[:drink_id]
        @drink = Drink.find(params[:drink_id])
      elsif params[:id]
        @drink = current_user.wishes.find(params[:id]).drink
      end
    
      respond_with current_user.removeFromWishList(@drink)
    end  
  end
end

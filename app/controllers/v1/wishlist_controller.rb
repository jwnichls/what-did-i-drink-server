module V1
  class WishlistController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
    before_action :doorkeeper_authorize!

    # GET /wishlist.json
    def index
      pagesize = params[:pagesize].nil? ? 20 : params[:pagesize]    
      if params[:page] && params[:page] == "all"
        @wishes = current_user.wishes.all
      else
        @wishes = current_user.wishes.paginate(:per_page => 20, :page => params[:page])
      end    

      respond_with @wishes
    end
  
    # POST /wishlist.json
    def create
      @drink = Drink.find(params[:drink_id])
      respond_with current_user.add_to_wish_list(@drink)
    end

    # DELETE /wishlist.json?drink_id=
    def destroy
      if params[:drink_id]
        @drink = Drink.find(params[:drink_id])
      elsif params[:id]
        @drink = current_user.wishes.find(params[:id]).drink
      end
    
      respond_with current_user.remove_from_wish_list(@drink)
    end  
  end
end

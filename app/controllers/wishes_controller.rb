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
end

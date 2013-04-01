module V1
  class UsersController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
    before_filter :restrict_access

    # GET /users/
    # GET /users.json
    def index
      respond_with current_user
    end
    
    # GET /users/1
    # GET /users/1.json
    def show
      if params[:id]
        @user = User.find(params[:id])
      else
        @user = current_user
      end
    end

    # PUT /users/1
    # PUT /users/1.json
    def update
      if params[:id]
        @user = User.find(params[:id])
      else
        @user = current_user
      end

      respond_to do |format|
        if @user.id == current_user.id and @user.update_attributes(User.from_params(params))
          format.json { head :no_content }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def update_location
    @user = User.find(params[:id])
    @venue = Venue.find(params[:venue_id])
    
    @user.checkin_to_venue!(@venue)
    
    render :show
  end
end

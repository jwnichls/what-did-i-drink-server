module V1
  class CheckinsController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
    before_filter :restrict_access

    # GET /checkins
    # GET /checkins.json
    def index
      respond_with current_user.checkins
    end

    # GET /checkins/1
    # GET /checkins/1.json
    def show
      respond_with Checkin.find(params[:id])
    end

    # POST /checkins
    # POST /checkins.json
    def create
      @checkin = Checkin.new(Checkin.from_params(params))
      @checkin.user = current_user

      if @checkin.save
        @checkin.on_committed()
        
        respond_to do |format|
          format.json { render json: @checkin, status: :created, location: @checkin }
        end
      else
        respond_to do |format|
          format.json { render json: @checkin.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end

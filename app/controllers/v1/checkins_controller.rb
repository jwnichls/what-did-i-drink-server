module V1
  class CheckinsController < ApplicationController
    skip_before_action :verify_authenticity_token
    respond_to :json
    before_action :doorkeeper_authorize!

    # GET /checkins
    # GET /checkins.json
    def index
      pagesize = params[:pagesize].nil? ? 20 : params[:pagesize]
      since = DateTime.new(0)
      if params[:since]
        begin
          since = params[:since].to_datetime
        rescue
        end
      end
      
      if params[:page] && params[:page] == "all"
        @checkins = current_user.checkins.where(["created_at > ?", since]).order("created_at DESC").all
      else
        @checkins = current_user.checkins.where(["created_at > ?", since]).order("created_at DESC").paginate(:per_page => pagesize, :page => params[:page])
      end
      
      respond_with @checkins
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
      
      if @checkin.user and @checkin.user.venue
        @checkin.user.checkin_to_venue!(@checkin.user.venue)
      end

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

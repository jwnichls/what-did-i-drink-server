class CheckinsController < ApplicationController
  # GET /checkins
  # GET /checkins.json
  def index
    @checkins = current_user.checkins.order("created_at DESC").all

    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
      format.json { render json: @checkins }
    end
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    @checkin = Checkin.find(params[:id])
    @image = Image.new
    @image.user = current_user
    @image.drink = @checkin.drink
    @image.checkin = @checkin

    session[:redirect] = checkin_path(@checkin)

    respond_to do |format|
      format.html # show.html.erb
      format.mobile # show.mobile.erb
      format.json { render json: @checkin }
    end
  end

  # GET /checkins/new
  # GET /checkins/new.json
  def new
    @checkin = Checkin.new
    @checkin.drink = Drink.find(params[:drink_id])
    @checkin.user = current_user
    
    if current_user.venue
      @checkin.venue = current_user.venue
    end

    respond_to do |format|
      format.html # new.html.erb
      format.mobile # new.mobile.erb
      format.json { render json: @checkin }
    end
  end

  # POST /checkins
  # POST /checkins.json
  def create
    @checkin = Checkin.new(params[:checkin])
    @checkin.user = current_user

    if @checkin.user and @checkin.user.venue
      @checkin.user.checkin_to_venue!(@checkin.user.venue)
    end

    if @checkin.save
      @checkin.on_committed()

      respond_to do |format|
        format.html { redirect_to @checkin, notice: @checkin.user.full_name.to_s + ' checked in to ' + @checkin.drink.name.to_s }
        format.mobile { redirect_to @checkin, notice: @checkin.user.full_name.to_s + ' checked in to ' + @checkin.drink.name.to_s }
        format.json { render json: @checkin, status: :created, location: @checkin }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.mobile { render action: "new" }
        format.json { render json: @checkin.errors, status: :unprocessable_entity }
      end
    end
  end
end

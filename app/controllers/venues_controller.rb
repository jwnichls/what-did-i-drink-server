class VenuesController < ApplicationController
  autocomplete :drink, :name, :full => true

  # Random Questions and To Do Items
  #
  # * How to do a lat/long distance-based search?
  # * How to do a search that returns both drinks and venues?
  # * Need to implement an "I'm here now" feature
  # * Need to link drinks to locations with some variables

  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venues }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
    @venue = Venue.new
    if params[:lat]
      nearby = foursquare.venues.search(:ll => (params[:lat].to_s + "," + params[:lng].to_s))
      @venues = nearby["nearby"]
    else
      places = foursquare.venues.search(:query => params[:name], :ll => "48.857,2.349")
      @venues = places["places"]
    end      

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
  end

  # POST /venues
  # POST /venues.json
  def create
    if params["foursq_id"]
      @foursq_venue = foursquare.venues.find(params["foursq_id"])
      @venue = Venue.new_from_4sq(@foursq_venue)
    else
      @venue = Venue.new(params[:venue])
    end

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render json: @venue, status: :created, location: @venue }
      else
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end
  
  def search
    if params[:venue][:name] == ""
      redirect_to :controller => :venues, :action => :index
    end
    
    @query = params[:venue][:name]
    @venues = Venue.search(:all, :query => @query)
    
    if @venues.length == 1 or (@venues.length > 0 and @venues[0].name == @query)
      redirect_to @venues[0]
    else
      redirect_to :controller => :venues, :action => :index, :query => @query
    end
  end
end

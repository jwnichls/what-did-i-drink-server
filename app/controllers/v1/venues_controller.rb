module V1
  class VenuesController < ApplicationController
    respond_to :json
    doorkeeper_for :all, :except => [:show, :index, :search]

    # GET /venues
    # GET /venues.json
    def index
      pagesize = params[:pagesize].nil? ? 20 : params[:pagesize]
      since = DateTime.new(0)
      if params[:since]
        begin
          since = params[:since].to_datetime
        rescue
        end
      end
      
      if params[:lat] and params[:lng]
        @venues = Venue.visible.verified.near(:origin => [params[:lat],params[:lng]], :within => 5).all(:order => 'name')
      elsif params[:page] && params[:page] == "all"
        @venues = Venue.visible.verified.where(["updated_at > ?", since]).order("name DESC").all
      else
        @venues = Venue.visible.verified.where(["updated_at > ?", since]).order("name DESC").paginate(:per_page => pagesize, :page => params[:page])
      end

      respond_with @venues
    end

    # GET /venues/1
    # GET /venues/1.json
    def show
      @venue = Venue.find(params[:id])
    end

    # GET /venues/new
    # GET /venues/new.json
    def new
      @venue = Venue.new

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
  
    # POST /venues/1/verify
    def verify
      @venue = Venue.find(params[:id])

      respond_to do |format|
        if @venue.verify!
          format.html { redirect_to @venue, notice: 'Venue has been verified.' }
        else
          format.html { redirect_to @venue, notice: 'Verification failed. Try again!' }
        end
      end
    end
  
    def search
      if params[:venue][:name] == ""
        redirect_to :controller => :venues, :action => :index
      end
    
      @query = params[:venue][:name]
      if params[:lat][0] != ""
        lat = params[:lat][0]
      end
      if params[:lng][0] != ""
        lng = params[:lng][0]
      end
    
      if lat and lng
        @venues = Venue.visible.near(:origin => [lat,lng], :within => 5).search(:query => @query).all
      else
        @venues = Venue.visible.search(:query => @query).all(:order => "name")
      end
    
      if @venues.length == 1 or (@venues.length > 0 and @venues[0].name == @query)
        redirect_to @venues[0]
        return
      elsif current_user.foursquare? and lat and lng
        # :categories => "4d4b7105d754a06374d81259,4d4b7105d754a06376d81259"
        venues = foursquare.venues.search(:query => @query, :ll => "#{lat},#{lng}")
      
        puts "Venues: " + venues.to_s
      
        if venues
          @venues = []
          venues.each { |p|
            v = Venue.new_from_4sq(p)
            ve = Venue.find_by_foursq_id(v.foursq_id)
            if ve
              @venues.push(ve)
            elsif v.save
              @venues.push(v)
            end
          }
        else
          @venues = Venue.visible.search(:query => @query).all(:order => "name")
        end
      else
        @venues = Venue.visible.search(:query => @query).all(:order => "name")
      end
    
      if @venues.length == 1 or (@venues.length > 0 and @venues[0].name == @query)
        redirect_to @venues[0]
      else
        render :controller => :venues, :action => :index
      end
    end
  end
end

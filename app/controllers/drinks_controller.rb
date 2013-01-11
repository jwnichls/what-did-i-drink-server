class DrinksController < ApplicationController
  autocomplete :drink, :name, :full => true
  autocomplete :drink, :created_by

  # GET /drinks
  # GET /drinks.json
  def index
    @query = params[:query]
    if @query
      @drinks = Drink.search(:all, :query => @query, :order => 'name')
    else
      @drinks = Drink.visible.all(:order => 'name')
    end    

    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
      format.json { render json: @drinks }
    end
  end

  # GET /drinks/1
  # GET /drinks/1.json
  def show
    @drink = Drink.find(params[:id])

    session[:redirect] = drink_path(@drink)

    respond_to do |format|
      format.html # show.html.erb
      format.mobile # show.mobile.erb
      format.json { render json: @drink }
    end
  end

  # GET /drinks/new
  # GET /drinks/new.json
  def new
    @drink = Drink.new

    respond_to do |format|
      format.html # new.html.erb
      format.mobile # new.mobile.erb
      format.json { render json: @drink }
    end
  end

  # GET /drinks/1/edit
  def edit
    @drink = Drink.find(params[:id])
  end

  # POST /drinks
  # POST /drinks.json
  def create
    @drink = Drink.new(params[:drink])

    respond_to do |format|
      if @drink.save
        format.html { redirect_to @drink, notice: 'Drink was successfully created.' }
        format.mobile { redirect_to @drink, notice: 'Drink was successfully created.' }
        format.json { render json: @drink, status: :created, location: @drink }
      else
        format.html { render action: "new" }
        format.mobile { render action: "new" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /drinks/1
  # PUT /drinks/1.json
  def update
    @drink = Drink.find(params[:id])

    respond_to do |format|
      if @drink.update_attributes(params[:drink])
        format.html { redirect_to @drink, notice: 'Drink was successfully updated.' }
        format.mobile { redirect_to @drink, notice: 'Drink was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.mobile { render action: "edit" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drinks/1
  # DELETE /drinks/1.json
  def destroy
    @drink = Drink.find(params[:id])
    @drink.hide

    respond_to do |format|
      format.html { redirect_to drinks_url }
      format.mobile { redirect_to drinks_url }
      format.json { head :no_content }
    end
  end
  
  
  def search
    if (params[:drink][:name] == "")
      redirect_to :controller => :drinks, :action => :index
    end
    
    @query = params[:drink][:name]
    @drinks = Drink.search(:all, :query => @query)
    
    if @drinks.length == 1 or (@drinks.length > 0 and @drinks[0].name == params[:drink][:name])
      redirect_to @drinks[0]
    else
      redirect_to :controller => :drinks, :action => :index, :query => @query
    end
  end
end

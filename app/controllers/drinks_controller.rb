require 'will_paginate/array'

class DrinksController < ApplicationController
  autocomplete :drink, :name, :full => true

  # GET /drinks
  # GET /drinks.json
  def index
    @query = params[:query]
    if @query
      @drinks = Drink.visible.search(:query => @query).paginate(:per_page => 20, :page => params[:page])
    else
      @drinks = Drink.visible.order("name").paginate(:per_page => 20, :page => params[:page])
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
    @image = Image.new
    @image.user = current_user
    @image.drink = @drink

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
    unless restrict_access
      @drink = Drink.new
      
      if params[:name]
        @drink.name = params[:name]
      end

      respond_to do |format|
        format.html # new.html.erb
        format.mobile # new.mobile.erb
        format.json { render json: @drink }
      end
    end
  end

  # GET /drinks/1/edit
  def edit
    unless restrict_access
      @drink = Drink.find(params[:id])
    end
  end

  # POST /drinks
  # POST /drinks.json
  def create
    unless restrict_access
      @drink = Drink.new(params[:drink])

      if @drink.save
        @drink.on_committed(current_user)
      
        respond_to do |format|
          format.html { redirect_to @drink, notice: 'Drink was successfully created.' }
          format.mobile { redirect_to @drink, notice: 'Drink was successfully created.' }
          format.json { render json: @drink, status: :created, location: @drink }
        end
      else
        respond_to do |format|
          format.html { render action: "new" }
          format.mobile { render action: "new" }
          format.json { render json: @drink.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /drinks/1
  # PUT /drinks/1.json
  def update
    unless restrict_access
      @drink = Drink.find(params[:id])

      if @drink.update_attributes(params[:drink])
        @drink.on_updated(current_user)
      
        respond_to do |format|
          format.html { redirect_to @drink, notice: 'Drink was successfully updated.' }
          format.mobile { redirect_to @drink, notice: 'Drink was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render action: "edit" }
          format.mobile { render action: "edit" }
          format.json { render json: @drink.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /drinks/1
  # DELETE /drinks/1.json
  def destroy
    unless restrict_access
      @drink = Drink.find(params[:id])
      @drink.hide

      respond_to do |format|
        format.html { redirect_to drinks_url }
        format.mobile { redirect_to drinks_url }
        format.json { head :no_content }
      end
    end
  end
  
  def search
    if (params[:drink][:name] == "")
      redirect_to :controller => :drinks, :action => :index
    end
    
    @query = params[:drink][:name]
    @drinks = Drink.visible.search(:query => @query).paginate(:per_page => 20, :page => params[:page])
    
    if @drinks.length == 1 or (@drinks.length > 0 and @drinks[0].name == @query)
      redirect_to @drinks[0]
    else
      respond_to do |format|
        format.html { render :controller => :drinks, :action => :index }
        format.mobile { render :controller => :drinks, :action => :index }
        format.json { render json: @drinks }
      end
    end
  end

  def listitems
    @selected_id = -1
    if params[:selected]
      @selected_id = params[:selected].to_i
    end
    
    @showpage = (params[:page] == nil or params[:page].to_i < 1)
    if params[:query]
      @drinks = Drink.visible.search(:query => params[:query]).order("name").paginate(:per_page => 20, :page => params[:page])
    else
      @drinks = Drink.visible.order("name").paginate(:per_page => 20, :page => params[:page])
    end
    
    respond_to do |format|
      format.mobile { render layout: nil } # listitems.mobile.erb
      format.json { render json: @drinks }
    end
  end
  
  # autocomplete :drink, :created_by
  # This version ensures that the created_by values returned are unique
  def autocomplete_drink_created_by
    term = params[:term]
    if term && !term.empty?
      items = Drink.select("distinct created_by").
              where("LOWER(created_by) like ?", term.downcase + '%').
              limit(10).order(:created_by)
    else
      items = {}
    end
    render :json => json_for_autocomplete(items, :created_by)
  end
  
  def format
    respond_to do |format|
      format.html # format.html.erb
      format.mobile {render :layout => "basic_dialog"}# format.mobile.erb
    end
  end
end

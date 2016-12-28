module V1
  class DrinksController < ApplicationController
    skip_before_action :verify_authenticity_token
    respond_to :json
    before_action :doorkeeper_authorize!, :except => [:show, :index, :search]
    
    # GET /drinks.json
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
        @drinks = Drink.visible.where(["updated_at > ?", since]).order("name DESC").all
      else
        @drinks = Drink.visible.where(["updated_at > ?", since]).order("name DESC").paginate(:per_page => pagesize, :page => params[:page])
      end
    end

    # GET /drinks/1.json
    def show
      @drink = Drink.find(params[:id])
    end

    # POST /drinks.json
    def create
      #unless restrict_access
        @drink = Drink.create(Drink.from_params(params))

        # TODO: Make sure this actually works
        if @drink != nil
          @drink.on_committed(current_user)
        end
      #end
    end

    # PUT /drinks/1.json
    def update
      #unless restrict_access
        @drink = Drink.update(params[:id], Drink.from_params(params))

        # TODO: Make sure this actually works
        if @drink != nil
          @drink.on_updated(current_user)
        end
      #end
    end

    # DELETE /drinks/1.json
    def destroy
      #unless restrict_access
        @drink = Drink.find(params[:id])
        @drink.hide()
        
        respond_with :no_content
      #end
    end

    # POST /drinks/search.json
    def search
      @drinks = Drink.search(:query => params[:query]).order("name").all
    end
  end
end

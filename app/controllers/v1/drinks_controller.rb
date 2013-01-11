module V1
  class DrinksController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
    
    # GET /drinks.json
    def index
      respond_with Drink.visible.all(:order => 'name')
    end

    # GET /drinks/1.json
    def show
      respond_with Drink.find(params[:id])
    end

    # POST /drinks.json
    def create
      unless restrict_access
        respond_with Drink.create(Drink.from_params(params))
      end
    end

    # PUT /drinks/1.json
    def update
      unless restrict_access
        respond_with Drink.update(params[:id], Drink.from_params(params))
      end
    end

    # DELETE /drinks/1.json
    def destroy
      unless restrict_access
        @drink = Drink.find(params[:id])
        @drink.hide()
        
        respond_with :no_content
      end
    end

    # POST /drinks/search.json
    def search
      respond_with Drink.search(:all, :query => params[:query])
    end
  end
end

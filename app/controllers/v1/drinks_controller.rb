module V1
  class DrinksController < ApplicationController
    skip_before_filter  :verify_authenticity_token
    respond_to :json
    
    # GET /drinks.json
    def index
      respond_with Drink.all(:order => 'name')
    end

    # GET /drinks/1.json
    def show
      respond_with Drink.find(params[:id])
    end

    # POST /drinks.json
    def create
      respond_with Drink.create(Drink.from_params(params))
    end

    # PUT /drinks/1.json
    def update
      respond_with Drink.update(params[:id], Drink.from_params(params))
    end

    # DELETE /drinks/1.json
    def destroy
      respond_with Drink.destroy(params[:id])
    end

    # POST /drinks/search.json
    def search
      respond_with Drink.search(:all, :query => params[:drink][:name])
    end
  end
end

module V1
  class DrinksController < ApplicationController
    # GET /drinks.json
    def index
      @drinks = Drink.all(:order => 'name')

      respond_to do |format|
        format.json { render json: @drinks }
      end
    end

    # GET /drinks/1.json
    def show
      @drink = Drink.find(params[:id])

      respond_to do |format|
        format.json { render json: @drink }
      end
    end

    # POST /drinks.json
    def create
      @drink = Drink.new(params[:drink])

      respond_to do |format|
        if @drink.save
          format.json { render json: @drink, status: :created, location: @drink }
        else
          format.json { render json: @drink.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /drinks/1.json
    def update
      @drink = Drink.find(params[:id])

      respond_to do |format|
        if @drink.update_attributes(params[:drink])
          format.json { head :no_content }
        else
          format.json { render json: @drink.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /drinks/1.json
    def destroy
      @drink = Drink.find(params[:id])
      @drink.destroy

      respond_to do |format|
        format.json { head :no_content }
      end
    end

    # POST /drinks/search.json
    def search
      @query = params[:drink][:name]
      @drinks = Drink.search(:all, :query => @query)
  

      respond_to do |format|
        format.json { render json: @drinks }
      end
    end
  end
end

module V1
  class DrinksController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
    
    # GET /drinks.json
    def index
      @drinks = Drink.visible.all(:order => 'name')
    end

    # GET /drinks/1.json
    def show
      @drink = Drink.find(params[:id])
    end

    # POST /drinks.json
    def create
      unless restrict_access
        @drink = Drink.create(Drink.from_params(params))

        # TODO: Make sure this actually works
        if @drink != nil
          @drink.on_committed(current_user)
        end
      end
    end

    # PUT /drinks/1.json
    def update
      unless restrict_access
        @drink = Drink.update(params[:id], Drink.from_params(params))

        # TODO: Make sure this actually works
        if @drink != nil
          @drink.on_updated(current_user)
        end
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
      @drinks = Drink.search(:query => params[:query]).all(:order => :name)
    end
  end
end

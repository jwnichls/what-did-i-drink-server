class ImagesController < ApplicationController
  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(params[:image])
    @image.user = current_user

    if @image.save
      @redirect = @drink
      if session[:redirect]
        @redirect = session[:redirect]
      end

      redirect_to @redirect
    else
      render session[:redirect]
    end
  end
end

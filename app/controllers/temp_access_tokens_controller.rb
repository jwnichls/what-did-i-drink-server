class TempAccessTokensController < ApplicationController

  # GET /temp_access_tokens
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: current_user.temp_access_tokens }
    end
  end

  # POST /temp_access_tokens
  def create
    @temp_access_token = TempAccessToken.new()
    @temp_access_token.token = SecureRandom.urlsafe_base64.to_s
    @temp_access_token.user = current_user

    respond_to do |format|
      if @temp_access_token.save
        redirect_to temp_access_tokens_path
      else
        format.html { render action: "new" }
      end
    end
  end
end

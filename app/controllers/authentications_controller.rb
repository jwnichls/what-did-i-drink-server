class AuthenticationsController < ApplicationController
  
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
    session[:redirect] = "/authentications"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # POST /authentications
  # POST /authentications.json
  def create
    auth = request.env["omniauth.auth"]
    create_flag = false
    
    puts "Provider: " + auth['provider']
    
    if !logged_in?
      authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
      
      if authentication == nil
        create_user(auth, params)
        create_flag = true
      end
            
      authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
      login_user(authentication.user)

      # if we don't have an image URL for this user yet, then capture it
      if auth['info']['image'] != nil and (current_user.image_url == nil or current_user.image_url == "")
        current_user.image_url = auth['info']['image']
        current_user.save
      end
    else
      current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])    
    end

    process_tokens(auth, params)

    puts "This is a test ***************************"
    puts "User: " + current_user.to_s

    if create_flag 
      @redirect = edit_user_path(current_user)
    elsif session[:redirect] == nil
      @redirect = authentications_url
    else
      @redirect = session[:redirect]
    end

    respond_to do |format|
      format.html { redirect_to @redirect }
      format.mobile { redirect_to @redirect }
      format.json { render json: current_user }
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    
    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json { head :no_content }
    end
  end
  
  private

  def create_user(auth, params)

    @user = User.new
    
    if auth['provider'] == 'identity'
      @user.email = Identity.find(auth['uid']).email
      @user.full_name = @user.email.slice(0,@user.email.index("@"))
    else
      @user.full_name = auth['info']['name']
      @user.image_url = auth['info']['image']
      @user.email = auth['info']['email']
    end

    if @user.save
      @user.on_committed

      @authentication = Authentication.create(:provider => auth['provider'], :uid => auth['uid'])
      @user.authentications << @authentication
    
      return @user
    else
      return nil
    end
  end
  
  def process_tokens(auth, params)
    if auth['provider'] == 'foursquare' and params['code'] != nil
      
      get_and_save_foursquare_token(params['code'])
    
    elsif auth['provider'] == 'twitter' and auth['credentials'] != nil

      get_and_save_twitter_token(auth['credentials'])
    
    end
  end
  
  def get_and_save_foursquare_token(code)  
    if current_user != nil and code != nil and current_user.foursquare_access_token == nil
      token = foursquare.access_token(code, ENV['FOURSQUARE_REDIRECT_URI'])
      puts "Foursquare token: " + token

      current_user.foursquare_access_token = token
      current_user.save
    end
  end
  
  def get_and_save_twitter_token(credentials)    
    if current_user != nil and credentials != nil and current_user.twitter_access_token == nil
      puts "Twitter Token: " + credentials.to_s
      
      current_user.twitter_access_token = credentials.token
      current_user.twitter_access_secret = credentials.secret
      current_user.save
    end
  end
end

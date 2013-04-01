class User < ActiveRecord::Base
  attr_accessible :admin, :email, :foursquare_access_token, :full_name, :image_url, :password, :twitter_access_secret, :twitter_access_token
  has_many :authentications
  has_many :checkins
  has_many :wishes
  has_many :temp_access_tokens
  has_many :timeline_entries
  has_many :images
  belongs_to :venue
  validates_presence_of :full_name

  def twitter?
    twitter_access_token != nil and twitter_access_secret != nil
  end
  
  def twitter
    if twitter?
      Twitter::Client.new(
        :oauth_token => twitter_access_token,
        :oauth_token_secret => twitter_access_secret
      )
    end
  end

  def foursquare?
    foursquare_access_token != nil
  end
  
  def foursquare
    if foursquare?
      Foursquare::Base.new(foursquare_access_token)
    end
  end
  
  def add_to_wish_list(drink)
    if !Wish.find_by_drink_id_and_user_id(drink.id, self.id)
      Wish.create({drink: drink, user: self})
      
      # Create the timeline entry for adding this new drink to the wish list
      WishForDrink.create({user: self, drink: drink})
    end
  end
  
  def remove_from_wish_list(drink)
    @wish = Wish.find_by_drink_id_and_user_id(drink.id, self.id)
    
    if @wish
      @wish.destroy
    end
  end
  
  def wished_for?(drink)
    Wish.find_by_drink_id_and_user_id(drink.id, self.id) != nil
  end
  
  def on_committed()
    # Create the timeline entry for this checkin
    NewUser.create({user: self})
  end

  def checkin_to_venue!(venue)
    self.venue = venue
    self.venue_updated_at = Time.now
    self.save
    
    if venue.verified
      venue.verify!
    end
  end
  
  def self.from_params(params)
    userparams = {}
    
    if params[:full_name]
      userparams[:full_name] = params[:full_name]
    end

    if params[:email]
      userparams[:email] = params[:email]
    end

    if params[:image_url]
      userparams[:image_url] = params[:image_url]
    end
    
    userparams
  end

  def self.check_out_old_locations!
    User.update_all({:venue_id => nil, :venue_updated_at => nil}, ["venue_updated_at < ?", 3.hours.ago])
  end
end

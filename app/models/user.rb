class User < ActiveRecord::Base
  attr_accessible :admin, :email, :foursquare_access_token, :full_name, :image_url, :password, :twitter_access_secret, :twitter_access_token
  has_many :authentications
  has_many :drinks, :through => :checkins
  has_many :drinks, :through => :waitlists

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
end

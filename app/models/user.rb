class User < ActiveRecord::Base
  attr_accessible :admin, :email, :foursquare_access_token, :full_name, :image_url, :password, :twitter_access_secret, :twitter_access_token
  has_many :authentications
  has_many :drinks, :through => :checkins
  has_many :drinks, :through => :waitlists
  
  def twitter
    Twitter::Client.new(
      :oauth_token => twitter_access_token,
      :oauth_token_secret => twitter_access_secret
    )
  end
  
  def foursquare
    Foursquare::Base.new(foursquare_access_token)
  end
end

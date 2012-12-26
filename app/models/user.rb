class User < ActiveRecord::Base
  attr_accessible :admin, :email, :foursquare_access_token, :full_name, :image_url, :password, :twitter_access_secret, :twitter_access_token
  has_many :drinks, :through => :checkins
  has_many :drinks, :through => :waitlists
end

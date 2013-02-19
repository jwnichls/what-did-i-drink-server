class Image < ActiveRecord::Base
  attr_accessible :checkin_id, :drink, :drink_id, :image, :user, :venue, :user_id, :venue_id, :checkin
  belongs_to :drink
  belongs_to :checkin
  belongs_to :user
  belongs_to :venue
  mount_uploader :image, ImageUploader
end

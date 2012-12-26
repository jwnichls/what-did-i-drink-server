class Checkin < ActiveRecord::Base
  attr_accessible :drink_id, :location, :notes, :user_id
  belongs_to :drink
  belongs_to :user
end

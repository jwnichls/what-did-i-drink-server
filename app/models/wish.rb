class Wish < ActiveRecord::Base
  attr_accessible :drink_id, :user_id
  belongs_to :user
  belongs_to :drink
end

class Wish < ActiveRecord::Base
  attr_accessible :drink_id, :user_id, :drink, :user
  belongs_to :user
  belongs_to :drink
end

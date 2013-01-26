class TimelineEntry < ActiveRecord::Base
  attr_accessible :description, :drink_id, :type, :user_id, :user, :drink
  belongs_to :user
  belongs_to :drink
end

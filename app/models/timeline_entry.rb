class TimelineEntry < ActiveRecord::Base
  attr_accessible :description, :drink_id, :type, :user_id
end

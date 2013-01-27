class Checkin < ActiveRecord::Base
  attr_accessible :drink_id, :location, :notes, :user_id
  belongs_to :drink
  belongs_to :user
  
  def self.from_params(params)
    checkinparams = {}
    
    if params[:drink_id]
      checkinparams[:drink_id] = params[:drink_id]
    end

    if params[:notes]
      checkinparams[:notes] = params[:notes]
    end

    if params[:location]
      checkinparams[:location] = params[:location]
    end
    
    checkinparams
  end
  
  def on_committed()
    # Remove the drink we checked into from the wish list (if it's there)
    self.user.removeFromWishList(self.drink)
    
    # Create the timeline entry for this checkin
    CheckinDrink.create({user: self.user, drink: self.drink})
  end
end

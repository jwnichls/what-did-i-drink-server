class Venue < ActiveRecord::Base
  attr_accessible :address, :city, :lat, :lng, :name, :postalCode, :state, :verified
  has_many :checkins
  has_many :images
  validates_presence_of :name
  validates_presence_of :city
  
  scope :visible, where(:deleted => :true)
  
  def self.search(*args)
    options = args.extract_options!
    find_by_sql [ "SELECT * FROM drinks WHERE deleted=false AND MATCH (name) AGAINST (?)", options[:query] ]
  end

  def self.new_from_4sq(foursq_venue)
    venue = Venue.new
    venue.foursq_id = foursq_venue.id
    venue.name = foursq_venue.name
    venue.address = foursq_venue.location.address    
    venue.postalCode = foursq_venue.location.postal_code
    venue.city = foursq_venue.location.city
    venue.state = foursq_venue.location.state
    venue.lat = foursq_venue.location.lat
    venue.lng = foursq_venue.location.lng
    venue.verified = foursq_venue.verified?
    
    venue
  end

  def hide
    self.deleted = true
    self.save
  end
  
  def restore
    self.deleted = false
    self.save
  end  
end

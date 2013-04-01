class Venue < ActiveRecord::Base
  attr_accessible :address, :city, :lat, :lng, :name, :postalCode, :state, :verified
  has_many :checkins
  has_many :images
  has_many :users
  validates_presence_of :name
  validates_presence_of :city
  
  scope :visible, where(:deleted => false)
  
  scope :verified, where(:verified => true)
  
  scope :near, lambda{ |*args|
                        origin = *args.first[:origin]
                        if (origin).is_a?(Array)
                          origin_lat, origin_lng = origin
                        else
                          origin_lat, origin_lng = origin.lat, origin.lng
                        end
                        origin_lat, origin_lng = Venue.deg2rad(origin_lat), Venue.deg2rad(origin_lng)
                        within = *args.first[:within]
                        
                        if within.length > 0
                          {
                            :conditions => %(
                              (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(venues.lat))*COS(RADIANS(venues.lng))+
                              COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(venues.lat))*SIN(RADIANS(venues.lng))+
                              SIN(#{origin_lat})*SIN(RADIANS(venues.lat)))*3956.55) <= #{within[0]}
                            ),
                            :select => %( venues.*,
                              (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(venues.lat))*COS(RADIANS(venues.lng))+
                              COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(venues.lat))*SIN(RADIANS(venues.lng))+
                              SIN(#{origin_lat})*SIN(RADIANS(venues.lat)))*3956.55) AS distance
                            ),
                            :order => :distance
                          }
                        else
                          {
                            :select => %( venues.*,
                              (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(venues.lat))*COS(RADIANS(venues.lng))+
                              COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(venues.lat))*SIN(RADIANS(venues.lng))+
                              SIN(#{origin_lat})*SIN(RADIANS(venues.lat)))*3956.55) AS distance
                            ),
                            :order => :distance
                          }
                        end
                      }
  
  scope :search, lambda{ |*args|
                        query = *args.first[:query]
                        {
                          :conditions => %( MATCH (name) AGAINST ("#{query[0]}") )
                        }
                      }                    

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
    
    venue
  end
  
  def self.deg2rad(degrees)
    degrees.to_f / 180.0 * Math::PI
  end

  def self.rad2deg(rad)
    rad.to_f * 180.0 / Math::PI
  end

  def hide
    self.deleted = true
    self.save
  end
  
  def restore
    self.deleted = false
    self.save
  end  
  
  def verify!
    self.verified = true
    self.save
  end
  
  def self.delete_all_unverified!
    Venue.delete_all(:verified => false)
  end
end

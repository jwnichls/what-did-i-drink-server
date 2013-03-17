class Drink < ActiveRecord::Base
  attr_accessible :created_by, :name, :recipe, :urls
  has_many :checkins
  has_many :waitlists
  has_many :timeline_entries
  has_many :images
  validates_uniqueness_of :name
  
  scope :visible, where(:deleted => false)
  
  scope :search, lambda{ |*args|
                        query = *args.first[:query]
                        {
                          :conditions => %( MATCH (name, recipe, created_by) AGAINST ("#{query[0]}") )
                        }
                      }                    
  
  def self.from_params(params)
    drinkparams = {}
    
    if params[:name]
      drinkparams[:name] = params[:name]
    end

    if params[:recipe]
      drinkparams[:recipe] = params[:recipe]
    end

    if params[:created_by]
      drinkparams[:created_by] = params[:created_by]
    end

    if params[:urls]
      drinkparams[:urls] = params[:urls]
    end
    
    drinkparams
  end

  def hide
    self.deleted = true
    self.save
  end
  
  def restore
    self.deleted = false
    self.save
  end

  def on_committed(user)
    # Create the timeline entry for this creation
    AddDrink.create({user: user, drink: self})
  end
  
  def on_updated(user)
    # Create the timeline entry for this update
    EditDrink.create({user: user, drink: self})
  end

  def urls_array
    urlArray = self.urls.split("\n")
  end
end

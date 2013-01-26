class Drink < ActiveRecord::Base
  attr_accessible :created_by, :name, :recipe, :urls
  has_many :checkins
  has_many :waitlists
  has_many :timeline_entries
  
  scope :visible, where(:deleted => :true)
  
  def self.search(*args)
    options = args.extract_options!
    find_by_sql [ "SELECT * FROM drinks WHERE deleted=false AND MATCH (name, recipe, created_by) AGAINST (?)", options[:query] ]
  end

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
    AddDrinkEntry.create({user: user, drink: self})
  end
  
  def on_updated(user)
    # Create the timeline entry for this update
    EditDrinkEntry.create({user: user, drink: self})
  end

  def urls_array
    urlArray = self.urls.split("\n")
  end
end

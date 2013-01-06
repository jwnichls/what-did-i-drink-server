class Drink < ActiveRecord::Base
  attr_accessible :created_by, :name, :recipe, :urls
  has_many :checkins
  has_many :waitlists
  
  def self.search(*args)
    options = args.extract_options!
    find_by_sql [ "SELECT * FROM drinks WHERE MATCH (name, recipe, created_by) AGAINST (?)", options[:query] ]
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

  def urls_array
    urlArray = self.urls.split("\n")
  end
end

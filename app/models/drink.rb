class Drink < ActiveRecord::Base
  attr_accessible :created_by, :name, :recipe, :recipe_json, :urls
  serialize :recipe_json, JSON
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

  before_save :parse_recipe
  
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
  
  private
  
  def parse_recipe
    paragraphs = self.recipe.split(/[\s\r]*\n[\s\r]*\n/)

    units = ["oz", "oz.", "ounces", "dash", "dashes", "drop", "drops", "ml", "cl", "gil", "gills", "cup", "cups", "teaspoon", "tsp", "tablespoon", "tbsp"]
    glasses = ["rocks", "old fashioned", "cocktail", "collins", "nick and nora"]

    if paragraphs.size > 0
      self.recipe_json = {
        ingredients: [],
        garnish: "",
        instructions: "",
        comments: ""      
      }
      
      # parse the ingredient lines
    	paragraphs[0].each_line { |l|
    		l.strip!

        # TODO: Fix the ingredient line parsing
    		m = l.match(/^([\d\.\-]+)\s+(\w+)\s+(.*)/)
  		  i = {amount: "", units: "", ingredient: ""}
    		if m
    		  i[:amount] = m[1]

    		  if units.index(m[2])
    		    i[:units] = m[2]
    		    i[:ingredient] = m[3]
  		    else
  		      i[:ingredient] = m[2] + " " + m[3]
  		      i = i.slice!(:units)
		      end
        else
          i[:ingredient] = l
          i = i.slice(:ingredient)
    		end

        self.recipe_json[:ingredients].push(i)
    	}
    	
    	if paragraphs.size > 1
    	  self.recipe_json[:instructions] = paragraphs[1]
    	  
    	  ng = self.recipe_json[:instructions].match(/no garnish/i)
    	  g = self.recipe_json[:instructions].match(/garnish with ?a?n? ([^\.]*)/i)
    	  if ng
    	    self.recipe_json[:garnish] = "No garnish"
  	    elsif g
  	      self.recipe_json[:garnish] = g[1]
	      end
  	  end
  	  
  	  if paragraphs.size > 2
  	    self.recipe_json[:comments] = paragraphs[2]
  	    paragraphs.slice!(0,3)
    	  paragraphs.each { |p|
    	    self.recipe_json[:comments] += "\n\n" + p
    	  }
  	  end
    else
      # apparently there was no recipe entered, so we set the computed recipe to null
      self.recipe_json = nil
    end
  end
end

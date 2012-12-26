class Drink < ActiveRecord::Base
  attr_accessible :created_by, :name, :recipe, :urls
  has_many :checkins
  has_many :waitlists
  
  def self.search(*args)
    options = args.extract_options!
    find_by_sql [ "SELECT * FROM drinks WHERE MATCH (name, recipe, created_by) AGAINST (?)", options[:query] ]
  end

  def urls_array
    urlArray = self.urls.split("\n")
  end
end

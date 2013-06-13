drinks = Drink.find(:all)

drinks.each do |d|
  d.parse_recipe
  
  if d.recipe_json != nil
    d.save
  end
end

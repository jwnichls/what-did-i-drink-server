drinks = Drink.find(:all)

drinks.each do |d|
  if d.urls
    if !d.recipe
      d.recipe = ""
    else    
      d.recipe.strip!
    end
    
    d.urls.strip!
    d.recipe += "\n\n" + d.urls
    d.save
  end
end

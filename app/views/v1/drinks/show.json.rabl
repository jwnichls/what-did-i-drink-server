extends "v1/drinks/show_small"

# TODO: 
# recipe -> recipe_raw
# recipe_json -> recipe (only show if non-null)

object @drink
attributes :recipe => :recipe_raw
attributes :recipe_json => :recipe, :if => lambda { |m| m.recipe_json != nil }

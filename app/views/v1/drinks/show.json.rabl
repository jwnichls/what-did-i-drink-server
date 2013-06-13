extends "v1/drinks/show_small"

# TODO: 
# recipe -> recipe_raw
# recipe_json -> recipe (only show if non-null)

object @drink
attributes :recipe => :recipe_raw, :recipe_json => :recipe

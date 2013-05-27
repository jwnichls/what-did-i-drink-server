class AddRecipeJsonColumnToDrinkTable < ActiveRecord::Migration
  def change
    add_column :drinks, :recipe_json, :text
  end
end

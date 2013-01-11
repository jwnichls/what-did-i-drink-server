class AddDeletedToDrinkTable < ActiveRecord::Migration
  def change
    add_column :drinks, :deleted, :boolean, default: false, null: false
  end
end

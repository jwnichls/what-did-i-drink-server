class RemoveUrlsColumnFromDrinks < ActiveRecord::Migration
  def up
    remove_column :drinks, :urls
  end

  def down
    add_column :drinks, :urls, :text
  end
end

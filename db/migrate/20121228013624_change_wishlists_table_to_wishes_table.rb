class ChangeWishlistsTableToWishesTable < ActiveRecord::Migration
  def up
    drop_table :wishlists
    create_table :wishes do |t|
      t.integer :user_id
      t.integer :drink_id

      t.timestamps
    end
  end

  def down
    drop_table :wishes
    create_table :wishlists do |t|
      t.integer :user_id
      t.integer :drink_id

      t.timestamps
    end
  end
end

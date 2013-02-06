class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.integer :drink_id
      t.integer :user_id
      t.integer :checkin_id
      t.integer :venue_id

      t.timestamps
    end
  end
end

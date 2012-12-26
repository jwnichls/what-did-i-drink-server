class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :user_id
      t.integer :drink_id
      t.string :location
      t.text :notes

      t.timestamps
    end
  end
end

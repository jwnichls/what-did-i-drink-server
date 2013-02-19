class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name, :null => false
      t.string :address
      t.string :postalCode
      t.string :city, :null => false
      t.string :state
      t.float :lat
      t.float :lng
      t.boolean :verified, :default => false, :null => false
      t.boolean :deleted, :default => false, :null => false

      t.timestamps
    end
    
    add_column :checkins, :venue_id, :integer, null: true
    
    execute 'ALTER TABLE venues ENGINE = MyISAM'
    execute 'CREATE FULLTEXT INDEX fulltext_venues ON venues (name)'
  end
end

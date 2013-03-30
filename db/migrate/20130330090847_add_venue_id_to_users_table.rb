class AddVenueIdToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :venue_id, :integer
  end
end

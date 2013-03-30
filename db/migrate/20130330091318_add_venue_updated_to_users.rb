class AddVenueUpdatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :venue_updated_at, :datetime
  end
end

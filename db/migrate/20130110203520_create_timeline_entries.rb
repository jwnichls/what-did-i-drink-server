class CreateTimelineEntries < ActiveRecord::Migration
  def change
    create_table :timeline_entries do |t|
      t.integer :user_id
      t.integer :drink_id
      t.integer :type
      t.string :description

      t.timestamps
    end
  end
end

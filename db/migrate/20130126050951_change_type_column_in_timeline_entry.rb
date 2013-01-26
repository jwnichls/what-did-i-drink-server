class ChangeTypeColumnInTimelineEntry < ActiveRecord::Migration
  def up
    change_column :timeline_entries, :type, :string
  end

  def down
    change_column :timeline_entries, :type, :integer
  end
end

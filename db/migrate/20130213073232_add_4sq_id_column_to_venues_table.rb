class Add4sqIdColumnToVenuesTable < ActiveRecord::Migration
  def change
    add_column :venues, :foursq_id, :string
  end
end

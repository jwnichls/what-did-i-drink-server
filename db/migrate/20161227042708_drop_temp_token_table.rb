class DropTempTokenTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :temp_access_tokens
  end
end

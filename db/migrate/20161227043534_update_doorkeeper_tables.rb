class UpdateDoorkeeperTables < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :scopes, :string, { :null => false, :default => '' }
    change_column :oauth_access_grants, :redirect_uri, :text
  end
end

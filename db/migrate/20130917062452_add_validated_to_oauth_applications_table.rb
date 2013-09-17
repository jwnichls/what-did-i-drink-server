class AddValidatedToOauthApplicationsTable < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :validated, :boolean, :default => false
  end
end

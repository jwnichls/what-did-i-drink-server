class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :password
      t.string :email
      t.string :foursquare_access_token
      t.string :twitter_access_token
      t.string :twitter_access_secret
      t.string :image_url
      t.boolean :admin

      t.timestamps
    end
  end
end

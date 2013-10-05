# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130917062452) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "checkins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drink_id"
    t.string   "location"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "venue_id"
  end

  create_table "drinks", :force => true do |t|
    t.string   "name"
    t.text     "recipe"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.boolean  "deleted",     :default => false, :null => false
    t.text     "recipe_json"
  end

  add_index "drinks", ["name", "recipe", "created_by"], :name => "fulltext_drinks"

  create_table "identities", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "image"
    t.integer  "drink_id"
    t.integer  "user_id"
    t.integer  "checkin_id"
    t.integer  "venue_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",                            :null => false
    t.string   "uid",                             :null => false
    t.string   "secret",                          :null => false
    t.string   "redirect_uri",                    :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "validated",    :default => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "temp_access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "timeline_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drink_id"
    t.string   "type"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.string   "password"
    t.string   "email"
    t.string   "foursquare_access_token"
    t.string   "twitter_access_token"
    t.string   "twitter_access_secret"
    t.string   "image_url"
    t.boolean  "admin"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "venue_id"
    t.datetime "venue_updated_at"
  end

  create_table "venues", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "address"
    t.string   "postalCode"
    t.string   "city",                          :null => false
    t.string   "state"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "verified",   :default => false, :null => false
    t.boolean  "deleted",    :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "foursq_id"
  end

  add_index "venues", ["name"], :name => "fulltext_venues"

  create_table "wishes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drink_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

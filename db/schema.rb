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

ActiveRecord::Schema.define(:version => 20121227021801) do

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
  end

  create_table "drinks", :force => true do |t|
    t.string   "name"
    t.text     "recipe"
    t.string   "created_by"
    t.text     "urls"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "drinks", ["name", "recipe", "created_by"], :name => "fulltext_drinks"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
  end

  create_table "wishlists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drink_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

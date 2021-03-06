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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140209223405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["name"], name: "index_activities_on_name", unique: true, using: :btree

  create_table "cached_geocodings", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "response"
  end

  add_index "cached_geocodings", ["text"], name: "index_cached_geocodings_on_text", unique: true, using: :btree

  create_table "rinks", force: :cascade do |t|
    t.string   "name"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
  end

  add_index "rinks", ["name"], name: "index_rinks_on_name", unique: true, using: :btree

  create_table "scheduled_activities", force: :cascade do |t|
    t.integer  "rink_id"
    t.integer  "activity_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_age"
    t.integer  "end_age"
    t.string   "gender"
    t.string   "original_label"
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  add_index "scheduled_activities", ["start_time"], name: "index_scheduled_activities_on_start_time", using: :btree

end

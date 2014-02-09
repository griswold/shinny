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

ActiveRecord::Schema.define(version: 20140209193609) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["name"], name: "index_activities_on_name", unique: true

  create_table "age_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "age_groups", ["name"], name: "index_age_groups_on_name", unique: true

  create_table "rinks", force: true do |t|
    t.string   "name"
    t.decimal  "lat"
    t.decimal  "lon"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rinks", ["name"], name: "index_rinks_on_name", unique: true

  create_table "scheduled_activities", force: true do |t|
    t.integer  "rink_id"
    t.integer  "activity_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_age"
    t.integer  "end_age"
  end

end

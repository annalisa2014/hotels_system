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

ActiveRecord::Schema.define(version: 20180304231044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "descriptions", force: :cascade do |t|
    t.integer "hotel_id"
    t.string  "lang"
    t.text    "description"
  end

  add_index "descriptions", ["hotel_id"], name: "index_descriptions_on_hotel_id", using: :btree

  create_table "hotels", force: :cascade do |t|
    t.string  "name"
    t.string  "country_code"
    t.decimal "average_price"
    t.integer "views_count",   default: 0
  end

  create_table "managers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hotel_id"
  end

  add_index "managers", ["hotel_id", "user_id"], name: "index_managers_on_hotel_id_and_user_id", using: :btree
  add_index "managers", ["user_id", "hotel_id"], name: "index_managers_on_user_id_and_hotel_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "password"
    t.string  "salt"
    t.string  "language"
    t.string  "token"
    t.boolean "manager",    default: false
  end

end

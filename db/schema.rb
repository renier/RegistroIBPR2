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

ActiveRecord::Schema.define(version: 20140305014602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "checks", force: true do |t|
    t.integer  "number"
    t.decimal  "amount",      precision: 9, scale: 2, null: false
    t.text     "description"
    t.integer  "church_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checks", ["church_id"], name: "index_checks_on_church_id", using: :btree

  create_table "churches", force: true do |t|
    t.integer  "position"
    t.integer  "nth",        default: 0
    t.string   "prefix",     default: "Iglesia Bautista de"
    t.string   "name",                                       null: false
    t.string   "nickname"
    t.string   "town"
    t.integer  "size",       default: 0
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.integer  "salutation"
    t.string   "name",                        null: false
    t.string   "lastnames",                   null: false
    t.boolean  "sex",                         null: false
    t.integer  "role",                        null: false
    t.text     "description"
    t.boolean  "attended",    default: false
    t.boolean  "printed",     default: false
    t.boolean  "materials",   default: false
    t.integer  "church_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["church_id"], name: "index_people_on_church_id", using: :btree

end

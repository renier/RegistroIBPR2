# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_20_062330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checks", id: :serial, force: :cascade do |t|
    t.integer "number"
    t.decimal "amount", precision: 9, scale: 2, null: false
    t.text "description"
    t.integer "church_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["church_id"], name: "index_checks_on_church_id"
  end

  create_table "churches", id: :serial, force: :cascade do |t|
    t.integer "position"
    t.integer "nth", default: 0
    t.string "prefix", limit: 255, default: "Iglesia Bautista de"
    t.string "name", limit: 255, null: false
    t.string "nickname", limit: 255
    t.string "town", limit: 255
    t.integer "size", default: 0
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.integer "salutation"
    t.string "name", limit: 255, null: false
    t.string "lastnames", limit: 255, null: false
    t.boolean "sex", null: false
    t.integer "role", null: false
    t.text "description"
    t.boolean "attended", default: false
    t.boolean "printed", default: false
    t.boolean "materials", default: false
    t.integer "church_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", limit: 255
    t.index ["church_id"], name: "index_people_on_church_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end

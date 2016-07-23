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

ActiveRecord::Schema.define(version: 20160723091956) do

  create_table "amenities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "timestamps", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "amenities_properties", id: false, force: :cascade do |t|
    t.integer "amenity_id",  limit: 4
    t.integer "property_id", limit: 4
  end

  add_index "amenities_properties", ["amenity_id"], name: "index_amenities_properties_on_amenity_id", using: :btree
  add_index "amenities_properties", ["property_id"], name: "index_amenities_properties_on_property_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "full_name",  limit: 255
    t.string   "facet_name", limit: 255
    t.string   "data_name",  limit: 255
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "locations_properties", id: false, force: :cascade do |t|
    t.integer "location_id", limit: 4
    t.integer "property_id", limit: 4
  end

  add_index "locations_properties", ["location_id"], name: "index_locations_properties_on_location_id", using: :btree
  add_index "locations_properties", ["property_id"], name: "index_locations_properties_on_property_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "address1",       limit: 255
    t.string   "address2",       limit: 255
    t.string   "zipcode",        limit: 255
    t.integer  "price",          limit: 4
    t.integer  "square_footage", limit: 4
    t.string   "contact_number", limit: 255
    t.string   "contact_email",  limit: 255
    t.float    "latitude",       limit: 24
    t.float    "longitude",      limit: 24
    t.text     "description",    limit: 65535
    t.integer  "bedrooms",       limit: 4
    t.integer  "bathrooms",      limit: 4
    t.integer  "lease_length",   limit: 4
    t.integer  "owner_id",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.date     "rented_at"
    t.integer  "location_id",    limit: 4
  end

  create_table "properties_types", id: false, force: :cascade do |t|
    t.integer "type_id",     limit: 4
    t.integer "property_id", limit: 4
  end

  add_index "properties_types", ["property_id"], name: "index_properties_types_on_property_id", using: :btree
  add_index "properties_types", ["type_id"], name: "index_properties_types_on_type_id", using: :btree

  create_table "types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end

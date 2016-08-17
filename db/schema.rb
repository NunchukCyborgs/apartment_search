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

ActiveRecord::Schema.define(version: 20160817045546) do

  create_table "amenities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "icon",       limit: 255
  end

  create_table "amenities_properties", id: false, force: :cascade do |t|
    t.integer "amenity_id",  limit: 4
    t.integer "property_id", limit: 4
  end

  add_index "amenities_properties", ["amenity_id"], name: "index_amenities_properties_on_amenity_id", using: :btree
  add_index "amenities_properties", ["property_id"], name: "index_amenities_properties_on_property_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "imageable_id",      limit: 4
    t.string   "imageable_type",    limit: 255
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

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
    t.string   "parcel_number",  limit: 255
    t.string   "slug",           limit: 255
  end

  add_index "properties", ["parcel_number"], name: "index_properties_on_parcel_number", using: :btree
  add_index "properties", ["slug"], name: "index_properties_on_slug", unique: true, using: :btree

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

  create_table "users", force: :cascade do |t|
    t.string   "email",              limit: 255, null: false
    t.string   "crypted_password",   limit: 255
    t.string   "salt",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id", limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", using: :btree

end

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

ActiveRecord::Schema.define(version: 20161206014255) do

  create_table "amenities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "amenities_properties", id: false, force: :cascade do |t|
    t.integer "amenity_id",  limit: 4
    t.integer "property_id", limit: 4
  end

  add_index "amenities_properties", ["amenity_id"], name: "index_amenities_properties_on_amenity_id", using: :btree
  add_index "amenities_properties", ["property_id"], name: "index_amenities_properties_on_property_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "email",            limit: 255
    t.string   "phone",            limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "contactable_id",   limit: 4
    t.string   "contactable_type", limit: 255
  end

  add_index "contacts", ["email"], name: "index_contacts_on_email", using: :btree
  add_index "contacts", ["phone"], name: "index_contacts_on_phone", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

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
    t.string   "height",            limit: 255
    t.string   "width",             limit: 255
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "license_instances", force: :cascade do |t|
    t.integer  "license_id",  limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "verified_at"
  end

  add_index "license_instances", ["license_id"], name: "index_license_instances_on_license_id", using: :btree
  add_index "license_instances", ["user_id"], name: "index_license_instances_on_user_id", using: :btree
  add_index "license_instances", ["verified_at"], name: "index_license_instances_on_verified_at", using: :btree

  create_table "licenses", force: :cascade do |t|
    t.string   "value",                   limit: 255
    t.integer  "user_id",                 limit: 4
    t.datetime "claimed_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name",                    limit: 255
    t.string   "landlord_name",           limit: 255
    t.float    "average_landlord_rating", limit: 24
  end

  add_index "licenses", ["user_id"], name: "index_licenses_on_user_id", using: :btree

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

  create_table "payment_requests", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "property_id",       limit: 4
    t.datetime "verified_at"
    t.text     "potential_address", limit: 65535
    t.date     "due_on"
    t.string   "name",              limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "subtotal",          limit: 24
    t.integer  "unit",              limit: 4
  end

  add_index "payment_requests", ["property_id"], name: "index_payment_requests_on_property_id", using: :btree
  add_index "payment_requests", ["user_id"], name: "index_payment_requests_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "payment_request_id", limit: 4
    t.string   "charge_id",          limit: 255
    t.datetime "captured_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "payments", ["payment_request_id"], name: "index_payments_on_payment_request_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "address1",                limit: 255
    t.string   "address2",                limit: 255
    t.string   "zipcode",                 limit: 255
    t.integer  "price",                   limit: 4
    t.integer  "square_footage",          limit: 4
    t.string   "contact_number",          limit: 255
    t.string   "contact_email",           limit: 255
    t.float    "latitude",                limit: 24
    t.float    "longitude",               limit: 24
    t.text     "description",             limit: 65535
    t.integer  "bedrooms",                limit: 4
    t.float    "bathrooms",               limit: 24
    t.integer  "lease_length",            limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.date     "rented_at"
    t.string   "parcel_number",           limit: 255
    t.string   "slug",                    limit: 255
    t.integer  "license_id",              limit: 4
    t.datetime "available_at"
    t.string   "city",                    limit: 255
    t.string   "state",                   limit: 255
    t.float    "average_property_rating", limit: 24
    t.float    "average_combined_rating", limit: 24
    t.integer  "units",                   limit: 4
  end

  add_index "properties", ["license_id"], name: "index_properties_on_license_id", using: :btree
  add_index "properties", ["parcel_number"], name: "index_properties_on_parcel_number", using: :btree
  add_index "properties", ["slug"], name: "index_properties_on_slug", unique: true, using: :btree

  create_table "properties_types", id: false, force: :cascade do |t|
    t.integer "type_id",     limit: 4
    t.integer "property_id", limit: 4
  end

  add_index "properties_types", ["property_id"], name: "index_properties_types_on_property_id", using: :btree
  add_index "properties_types", ["type_id"], name: "index_properties_types_on_type_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "property_id",       limit: 4
    t.text     "body",              limit: 65535
    t.text     "title",             limit: 65535
    t.float    "property_rating",   limit: 24
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "landlord_rating",   limit: 24
    t.text     "landlord_comments", limit: 65535
    t.integer  "duration",          limit: 4
    t.datetime "anonymous_at"
    t.datetime "current_tenant_at"
    t.datetime "approved_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "scheduled_events", force: :cascade do |t|
    t.string   "event",      limit: 255
    t.string   "name",       limit: 255
    t.string   "at",         limit: 255
    t.integer  "frequency",  limit: 4
    t.string   "tz",         limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id",     limit: 255
    t.string   "provider",               limit: 255,   default: "email", null: false
    t.string   "uid",                    limit: 255,   default: "",      null: false
    t.string   "encrypted_password",     limit: 255,   default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,     default: 0,       null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.string   "image",                  limit: 255
    t.text     "tokens",                 limit: 65535
    t.datetime "verified_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "license_instances", "licenses"
  add_foreign_key "license_instances", "users"
  add_foreign_key "licenses", "users"
  add_foreign_key "payment_requests", "properties"
  add_foreign_key "payment_requests", "users"
  add_foreign_key "payments", "payment_requests"
  add_foreign_key "payments", "users"
  add_foreign_key "properties", "licenses"
end

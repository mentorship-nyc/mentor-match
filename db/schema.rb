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

ActiveRecord::Schema.define(version: 20140826222816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: true do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "description",             null: false
    t.string   "difficulty",  limit: 10,  null: false
    t.text     "problem",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider",      limit: 50,  null: false
    t.string   "uid",           limit: 25,  null: false
    t.string   "token",         limit: 100, null: false
    t.string   "refresh_token", limit: 100
    t.integer  "expires_at"
    t.string   "nickname",      limit: 100
    t.string   "email"
    t.string   "first_name",    limit: 50
    t.string   "last_name",     limit: 50
    t.string   "full_name",     limit: 100
    t.string   "image"
    t.string   "gender"
    t.string   "locale",        limit: 5
    t.string   "location",      limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer "user_id",                                 null: false
    t.string  "bio",          limit: 500,                null: false
    t.string  "availability", limit: 25,                 null: false
    t.string  "skills",                                  null: false
    t.string  "role",         limit: 25,                 null: false
    t.string  "name",         limit: 100,                null: false
    t.string  "image",                                   null: false
    t.string  "location",     limit: 100,                null: false
    t.string  "country",      limit: 50
    t.string  "timezone",     limit: 50
    t.boolean "active",                   default: true
  end

  add_index "profiles", ["availability", "skills", "role"], name: "index_profiles_on_availability_and_skills_and_role", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                           null: false
    t.string   "name",                 limit: 100,                null: false
    t.string   "image"
    t.string   "location",             limit: 100
    t.string   "country",              limit: 50
    t.string   "timezone",             limit: 50
    t.string   "confirmation_token",   limit: 50
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "active",                           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end

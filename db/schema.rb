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

ActiveRecord::Schema.define(version: 20140831070532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages_builds", force: true do |t|
    t.string   "status"
    t.string   "guid"
    t.string   "name"
    t.string   "name_with_owner"
    t.string   "sha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repository_id"
    t.string   "pusher"
  end

  create_table "repositories", force: true do |t|
    t.string   "owner"
    t.string   "name"
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_with_owner"
    t.integer  "hook_id"
  end

  add_index "repositories", ["name_with_owner"], name: "index_repositories_on_name_with_owner", using: :btree

  create_table "users", force: true do |t|
    t.string  "login",                  null: false
    t.string  "token",     default: "", null: false
    t.integer "github_id",              null: false
    t.string  "email"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", using: :btree

end

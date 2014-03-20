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

ActiveRecord::Schema.define(version: 20140319221550) do

  create_table "accounts", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "service"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uniq"
    t.string   "ssoid"
    t.integer  "time"
  end

  create_table "books", force: true do |t|
    t.float    "price"
    t.float    "size"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "market_id"
    t.integer  "selection_id"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "open_date"
    t.string   "cc"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markets", force: true do |t|
    t.string   "name"
    t.float    "total_matched"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "market_id"
    t.boolean  "has_worker"
    t.string   "status"
  end

  create_table "runners", force: true do |t|
    t.integer  "runner_id"
    t.integer  "selection_id"
    t.string   "name"
    t.float    "handicap"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.integer  "auth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

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

ActiveRecord::Schema.define(version: 20150512032027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ignored_users", force: :cascade do |t|
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ignored_users", ["user_id"], name: "index_ignored_users_on_user_id", using: :btree

  create_table "replies", force: :cascade do |t|
    t.string   "text"
    t.string   "tweet_id"
    t.string   "user_id"
    t.string   "user"
    t.string   "screen_name"
    t.boolean  "responded_to"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "replies", ["tweet_id"], name: "index_replies_on_tweet_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.string   "text"
    t.string   "tweet_id"
    t.string   "user_id"
    t.string   "user"
    t.string   "screen_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "mentioned_ids"
  end

  add_index "tweets", ["tweet_id"], name: "index_tweets_on_tweet_id", using: :btree

end

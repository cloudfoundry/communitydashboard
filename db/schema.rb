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

ActiveRecord::Schema.define(version: 20130920045620) do

  create_table "github_users", force: true do |t|
    t.integer  "pull_requesst_id", null: false
    t.string   "login",            null: false
    t.integer  "github_user_id",   null: false
    t.string   "gravatar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pull_requests", force: true do |t|
    t.integer  "github_id",        null: false
    t.integer  "number",           null: false
    t.string   "state",            null: false
    t.string   "title",            null: false
    t.text     "body"
    t.string   "head",             null: false
    t.datetime "gh_created_at"
    t.datetime "gh_updated_at"
    t.datetime "closed_at"
    t.datetime "merged_at"
    t.string   "merge_commit_sha"
    t.boolean  "merged"
    t.boolean  "mergeable"
    t.string   "mergeable_state"
    t.integer  "comments"
    t.integer  "review_comments"
    t.integer  "commits"
    t.integer  "additions"
    t.integer  "deletions"
    t.integer  "changed_files"
    t.string   "organization"
    t.string   "repository"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

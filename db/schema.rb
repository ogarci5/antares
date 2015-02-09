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

ActiveRecord::Schema.define(version: 20150209064200) do

  create_table "progresses", force: :cascade do |t|
    t.integer  "task_id",     limit: 4
    t.date     "date"
    t.text     "description", limit: 65535
    t.string   "value",       limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "progresses", ["task_id"], name: "index_progresses_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "goal",              limit: 255
    t.text     "description",       limit: 65535
    t.date     "due_date"
    t.boolean  "completed",         limit: 1
    t.string   "type",              limit: 255
    t.integer  "priority",          limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "recurring",         limit: 1
    t.string   "period",            limit: 255
    t.boolean  "remind_me",         limit: 1
    t.datetime "last_completed_at"
    t.integer  "task_id",           limit: 4
  end

  add_index "tasks", ["task_id"], name: "index_tasks_on_task_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",   limit: 255
    t.string   "last_name",    limit: 255
    t.string   "phone_number", limit: 255
    t.string   "role",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_foreign_key "progresses", "tasks"
end

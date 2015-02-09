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

ActiveRecord::Schema.define(version: 20150209040453) do

  create_table "progresses", force: :cascade do |t|
    t.integer  "task_id"
    t.date     "date"
    t.text     "description"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "progresses", ["task_id"], name: "index_progresses_on_task_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.string   "goal"
    t.text     "description"
    t.date     "due_date"
    t.boolean  "completed"
    t.string   "type"
    t.integer  "priority"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "recurring"
    t.string   "period"
    t.boolean  "remind_me"
    t.datetime "last_completed_at"
    t.integer  "task_id"
  end

  add_index "tasks", ["task_id"], name: "index_tasks_on_task_id"

end

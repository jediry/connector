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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925075612) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "detail"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "addresses", ["person_id"], :name => "index_addresses_on_person_id"

  create_table "group_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "group_type_id"
    t.integer  "meeting_day"
    t.time     "meeting_time"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "description"
    t.text     "restrictions"
  end

  create_table "groups_people", :id => false, :force => true do |t|
    t.integer "group_id",  :null => false
    t.integer "person_id", :null => false
  end

  add_index "groups_people", ["group_id", "person_id"], :name => "index_groups_people_on_group_id_and_person_id", :unique => true

  create_table "notes", :force => true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "notes", ["task_id"], :name => "index_notes_on_task_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "task_statuses", :force => true do |t|
    t.string   "description"
    t.integer  "task_type_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "active",       :default => true,  :null => false
    t.boolean  "start",        :default => false, :null => false
    t.boolean  "finish",       :default => false, :null => false
  end

  create_table "task_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "title_template"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "task_type_id"
    t.integer  "person_id"
    t.integer  "user_id"
    t.integer  "task_status_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "tasks", ["person_id"], :name => "index_tasks_on_person_id"
  add_index "tasks", ["task_status_id"], :name => "index_tasks_on_task_status_id"
  add_index "tasks", ["task_type_id"], :name => "index_tasks_on_task_type_id"
  add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "person_id"
    t.string   "username"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "active",          :default => true
    t.boolean  "admin"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users", ["person_id"], :name => "index_users_on_person_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end

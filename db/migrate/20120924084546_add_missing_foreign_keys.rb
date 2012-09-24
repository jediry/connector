class AddMissingForeignKeys < ActiveRecord::Migration
  def up
    # Oops...the original create_table migration failed to set up the primary key! O_o
    change_table :users do |t|
      t.change :person_id, :primary_key
    end

    add_foreign_key "addresses", "people", :name => "addresses_person_id_fk"
    add_foreign_key "groups", "group_types", :name => "groups_group_type_id_fk"
    add_foreign_key "groups_people", "groups", :name => "groups_people_group_id_fk"
    add_foreign_key "groups_people", "people", :name => "groups_people_person_id_fk"
    add_foreign_key "groups", "users", :name => "groups_user_id_fk", :primary_key => "person_id"
    add_foreign_key "notes", "tasks", :name => "notes_task_id_fk"
    add_foreign_key "notes", "users", :name => "notes_user_id_fk", :primary_key => "person_id"
    add_foreign_key "task_statuses", "task_types", :name => "task_statuses_task_type_id_fk"
    add_foreign_key "tasks", "people", :name => "tasks_person_id_fk"
    add_foreign_key "tasks", "task_statuses", :name => "tasks_task_status_id_fk"
    add_foreign_key "tasks", "task_types", :name => "tasks_task_type_id_fk"
    add_foreign_key "tasks", "users", :name => "tasks_user_id_fk", :primary_key => "person_id"
    add_foreign_key "users", "people", :name => "users_person_id_fk"
  end

  def down
    change_table :users do |t|
      t.change :person_id, :integer
    end

    remove_foreign_key "addresses", :name => "addresses_person_id_fk"
    remove_foreign_key "groups", :name => "groups_group_type_id_fk"
    remove_foreign_key "groups_people", :name => "groups_people_group_id_fk"
    remove_foreign_key "groups_people", :name => "groups_people_person_id_fk"
    remove_foreign_key "groups", :name => "groups_user_id_fk", :primary_key => "person_id"
    remove_foreign_key "notes", :name => "notes_task_id_fk"
    remove_foreign_key "notes", :name => "notes_user_id_fk", :primary_key => "person_id"
    remove_foreign_key "task_statuses", :name => "task_statuses_task_type_id_fk"
    remove_foreign_key "tasks", :name => "tasks_person_id_fk"
    remove_foreign_key "tasks", :name => "tasks_task_status_id_fk"
    remove_foreign_key "tasks", :name => "tasks_task_type_id_fk"
    remove_foreign_key "tasks", :name => "tasks_user_id_fk", :primary_key => "person_id"
    remove_foreign_key "users", :name => "users_person_id_fk"
  end
end

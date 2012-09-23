class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :task_type
      t.references :person
      t.references :user
      t.references :task_status

      t.timestamps
    end
    add_index :tasks, :task_type_id
    add_index :tasks, :person_id
    add_index :tasks, :user_id
    add_index :tasks, :task_status_id
  end
end

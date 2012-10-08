class CreateSubTaskTypes < ActiveRecord::Migration
  def change
    create_table :sub_task_types do |t|
      t.boolean :active, :null => false, :default => true
      t.references :task_type, :null => false
      t.references :task_status
      t.string :description, :null => false
      t.text :instructions
      t.integer :contact_within_days
      t.integer :contact_attempts_to_make

      t.timestamps
    end

    create_table :sub_tasks do |t|
      t.references :sub_task_type, :null => false
      t.references :task, :null => false
      t.datetime :completed_at

      t.timestamps
    end
  end
end

class CreateTaskStatuses < ActiveRecord::Migration
  def change
    create_table :task_statuses do |t|
      t.string :description
      t.references :task_type

      t.timestamps
    end
  end
end

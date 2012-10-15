class AddGroupTypeToTaskType < ActiveRecord::Migration
  def change
    add_column :task_types, :group_type_id, :integer
  end
end

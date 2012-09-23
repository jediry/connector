class AddStartAndFinishToTaskStatuses < ActiveRecord::Migration

  # Local model avoiding validations, since we're modifying the task_statuses table
  class TaskType < ActiveRecord::Base
    has_many :task_statuses
  end
  class TaskStatus < ActiveRecord::Base
    attr_accessible :start, :finish
    belongs_to :task_type
  end

  def up
    # Add :start and :finish columns
    add_column :task_statuses, :start,  :boolean, :null => false, :default => false
    add_column :task_statuses, :finish, :boolean, :null => false, :default => false

    # Fix up any existing task_types, so that they have a :start and :finish status
    say_with_time "Fixing up existing TaskTypes to have start/finish statuses" do
      TaskStatus.reset_column_information
      TaskType.all.each do |tt|
        say "Looking at \"#{tt.description}\""
        say "Making \"#{tt.task_statuses.first.description}\" a start status"
        tt.task_statuses.first.update_attributes!( :start => true )
        say "Making \"#{tt.task_statuses.last.description}\" a finish status"
        tt.task_statuses.last.update_attributes!( :finish => true )
      end
    end
  end

  def down
    remove_column :task_statuses, :start
    remove_column :task_statuses, :finish
  end
end

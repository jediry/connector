class TaskStatus < ActiveRecord::Base
  attr_accessible :description, :type
  belongs_to :task_type
end

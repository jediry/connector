class TaskStatus < ActiveRecord::Base
  attr_accessible :description, :type, :start, :finish
  belongs_to :task_type
end

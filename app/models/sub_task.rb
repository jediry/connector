class SubTask < ActiveRecord::Base
  attr_accessible :sub_task_type_id, :task_id, :completed_at

  belongs_to :sub_task_type
  belongs_to :task

  before_validation :fix_up_references

  validates :sub_task_type, :presence => true
  validates :task, :presence => true

private
  # Because FormBuilder::select only updates ids and not object references, we need this before_validation callback
  # to sync these two in order to ensure that we pass validation.
  def fix_up_references
    if self.sub_task_type.nil? and !self.sub_task_type_id.nil?
      self.sub_task_type = SubTaskType.find(self.sub_task_type_id)
    end
    if self.task.nil? and !self.task_id.nil?
      self.task = Task.find(self.task_id)
    end
  end
end

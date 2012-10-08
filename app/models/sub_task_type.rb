class SubTaskType < ActiveRecord::Base
  attr_accessible :task_type_id, :task_status_id, :active, :description, :instructions, :contact_within_days, :contact_attempts_to_make

  belongs_to :task_type
  belongs_to :task_status
  has_many :sub_tasks

  before_validation :fix_up_references

  validates :task_type, :presence => true
  validates :description, :presence => true

private
  # Because FormBuilder::select only updates ids and not object references, we need this before_validation callback
  # to sync these two in order to ensure that we pass validation.
  def fix_up_references
    if self.task_type.nil? and !self.task_type_id.nil?
      self.task_type = TaskType.find(self.task_type_id)
    end
    if self.task_status.nil? and !self.task_status_id.nil?
      self.task_status = TaskType.find(self.task_status_id)
    end
  end
end

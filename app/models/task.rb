class Task < ActiveRecord::Base
  attr_accessible :task_type_id, :person_id, :user_id, :task_status_id, :last_contact_attempt_made_at, :attempt_next_contact_by, :consecutive_failed_contact_attempts
  belongs_to :task_type
  belongs_to :person
  belongs_to :user
  belongs_to :task_status
  has_one :finish, :through => :task_status
  has_one :group_type, :through => :task_type
  has_many :sub_tasks
  has_many :notes

  before_validation :fix_up_references

  # Returns true if action was expected to have already happened on this task, but hasn't yet
  def overdue?
    !self.attempt_next_contact_by.nil? && self.attempt_next_contact_by < Time.current
  end

  def finished?
    self.task_status.finish
  end

private
  # Because FormBuilder::select only updates ids and not object references, we need this before_validation callback
  # to sync these two in order to ensure that we pass validation.
  def fix_up_references
    if self.user.nil? and !self.user_id.nil?
      self.user = User.find(self.user_id)
    end
    if self.task_status.nil? and !self.task_status_id.nil?
      self.task_status = TaskStatus.find(self.task_status_id)
    end
  end
end

class TaskType < ActiveRecord::Base
  attr_accessible :description, :title_template, :task_statuses_attributes
  has_many :task_statuses, :dependent => :destroy
  has_many :tasks

  accepts_nested_attributes_for :task_statuses, :reject_if => lambda { |a| a[:description].blank? }, :allow_destroy => true

  validates :description, :presence => true
  validates :title_template, :presence => true

  # Returns the collection of tasks of this type that are currently in-progress
  def in_progress_tasks
    Task.joins("inner join task_statuses on tasks.task_status_id = task_statuses.id").where('tasks.task_type_id' => self.id, 'task_statuses.finish' => false).order('created_at DESC')
  end

  # Returns the collection of all tasks of this type, including finished ones
  def tasks
    super.order('created_at DESC')
  end

#  TODO: figure out why this doesn't validate as expected
#  validate :must_have_exactly_one_start_and_at_least_one_finish_status

private
#  def must_have_exactly_one_start_and_at_least_one_finish_status
#    start_count = 0
#    finish_count = 0
#    task_statuses.all.each do |s|
#      if s.start?
#        start_count += 1
#      end
#      if s.finish?
#        finish_count += 1
#      end
#    end
#    if start_count != 1
#      errors.add(:task_statuses, "must have exactly one \"start\" status")
#    end
#    if finish_count == 0
#      errors.add(:task_statuses, "must have at least one \"finish\" status")
#    end
#  end
end

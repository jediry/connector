class TaskType < ActiveRecord::Base
  attr_accessible :description, :task_statuses_attributes
  has_many :task_statuses, :dependent => :destroy

  accepts_nested_attributes_for :task_statuses, :reject_if => lambda { |a| a[:description].blank? }, :allow_destroy => true

  validates :description, :presence => true
end

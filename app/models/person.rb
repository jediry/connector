class Person < ActiveRecord::Base
  attr_accessible :name, :active, :email, :phone, :member, :address_attributes
  has_one :address, :dependent => :destroy
  has_and_belongs_to_many :groups, :uniq => true
  has_many :tasks

  accepts_nested_attributes_for :address, :allow_destroy => true

  before_validation :strip_phone_nonnumeric

  validates :name, :presence => true
  validates :phone, :length => { :minimum => 10 }
  validates :email, :format => { :with => /^[0-9a-z][0-9a-z.-]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z]$/xi }

  # Returns the collection of tasks related to this person that are currently in-progress
  def in_progress_tasks
    Task.joins('inner join task_statuses on tasks.task_status_id = task_statuses.id').where('tasks.person_id' => id, 'task_statuses.finish' => false)
  end

  # Returns the collection of groups that this person is not a member of
  def non_member_groups
    Group.joins("left outer join ( select * from groups_people where person_id = #{self.id} ) as gp on groups.id = gp.group_id").where('gp.person_id is NULL')
  end

private
  def strip_phone_nonnumeric
    if !self.phone.nil?
      self.phone = self.phone.gsub(/[^0-9]/, '')
    end
  end
end

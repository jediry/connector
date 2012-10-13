class Person < ActiveRecord::Base
  attr_accessible :name, :active, :email, :phone, :member, :address_attributes
  has_one :address, :dependent => :destroy
  has_many :group_memberships
  has_many :groups, :through => :group_memberships
  has_many :tasks

  accepts_nested_attributes_for :address, :allow_destroy => true

  # We don't care whether the user entered the phone like 2061234567 or (206) 123-4567...we store it as just digits
  before_validation :strip_phone_nonnumeric

  validates :name, :presence => true
  validates :phone, :length => { :minimum => 10 }, :unless => 'phone.blank?'
  validates :email, :format => { :with => /^[0-9a-z_][0-9a-z_.-]+[0-9a-z_]@[0-9a-z_][0-9a-z_.-]+[0-9a-z]$/xi }, :unless => 'email.blank?'

  # Returns the collection of tasks related to this person that are currently in-progress
  def in_progress_tasks
    Task.joins('inner join task_statuses on tasks.task_status_id = task_statuses.id').where('tasks.person_id' => id, 'task_statuses.finish' => false).order('created_at DESC')
  end

  def tasks
    super.order('created_at DESC')
  end

  # Returns the collection of groups that this person is not a member of
  def non_member_groups
    Group.joins("LEFT OUTER JOIN ( SELECT * FROM group_memberships WHERE person_id = #{self.id} ) AS gm ON groups.id = gm.group_id").where('gm.person_id IS NULL')
  end

  # Build objects for any missing associations
  def build_if_missing
    if self.address.nil?
      self.build_address
    end
  end

  # Static method to sanitze an attributes hash destined for update_attributes
  def self.sanitize_attributes(person_attributes)
    if !person_attributes.nil?
      person_attributes.delete(:phone) if !person_attributes[:phone].nil? && person_attributes[:phone].blank?
      person_attributes.delete(:email) if !person_attributes[:email].nil? && person_attributes[:email].blank?
      if Address.sanitize_attributes person_attributes[:address_attributes]
        person_attributes.delete(:address_attributes)
      end
    end
    return false # Don't delete me!
  end

private
  def strip_phone_nonnumeric
    if !self.phone.nil?
      self.phone = self.phone.gsub(/[^0-9]/, '')
    end
  end
end

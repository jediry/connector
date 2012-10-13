class Group < ActiveRecord::Base
  attr_accessible :name, :group_type_id, :region_id, :active, :description, :restrictions, :meeting_day, :meeting_time
  belongs_to :group_type
  belongs_to :region
  has_many :group_memberships
  has_many :leader_memberships, :class_name => 'GroupMembership', :conditions => 'leader = \'t\''
  has_many :contact_memberships, :class_name => 'GroupMembership', :conditions => 'contact = \'t\''
  has_many :host_memberships, :class_name => 'GroupMembership', :conditions => 'host = \'t\''
  has_many :members, :order => :name, :through => :group_memberships, :class_name => 'Person', :source => :person
  has_many :leaders, :order => :name, :through => :leader_memberships, :class_name => 'Person', :source => :person
  has_many :contacts, :order => :name, :through => :contact_memberships, :class_name => 'Person', :source => :person
  has_many :hosts, :order => :name, :through => :host_memberships, :class_name => 'Person', :source => :person

  before_validation :fix_up_references

  validates :name, :group_type, :meeting_day, :meeting_time, :presence => true

  # Returns the collection of people who are not members of this group
  def non_members
    Person.joins("LEFT OUTER JOIN ( SELECT * FROM group_memberships WHERE group_id = #{self.id} ) AS gm ON people.id = gm.person_id").where('gm.group_id IS NULL').order(:name)
  end

private
  # Because FormBuilder::select only updates ids and not object references, we need this before_validation callback
  # to sync these two in order to ensure that we pass validation.
  def fix_up_references
    if self.group_type.nil? and !self.group_type_id.nil?
      self.group_type = GroupType.find(self.group_type_id)
    end
    if self.region.nil? and !self.region_id.nil?
      self.region = Region.find(self.region_id)
    end
  end
end

class GroupMembership < ActiveRecord::Base
  attr_accessible :person_id, :group_id, :leader, :contact, :host
  belongs_to :person
  belongs_to :group
  has_many :tasks, :foreign_key => :contact_id

  validates :person, :group, :presence => true

  before_validation :fix_up_references

  def self.contacts(group_type)
    GroupMembership.where(:contact => true).joins('INNER JOIN users ON group_memberships.person_id = users.person_id').where('users.active = \'t\'')
  end

  def string_for_select
    region = ''
    if !group.region.nil?
      region = "[#{group.region.name}] "
    end
    "#{region}#{group.name}: #{person.name}"
  end

private
  # Because FormBuilder::select only updates ids and not object references, we need this before_validation callback
  # to sync these two in order to ensure that we pass validation.
  def fix_up_references
    if self.person.nil? and !self.person_id.nil?
      self.person = GroupType.find(self.person_id)
    end
    if self.group.nil? and !self.group_id.nil?
      self.group = Region.find(self.group_id)
    end
  end
end

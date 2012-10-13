class GroupMembership < ActiveRecord::Base
  attr_accessible :person_id, :group_id, :leader, :contact, :host
  belongs_to :person
  belongs_to :group

  validates :person, :group, :presence => true
end

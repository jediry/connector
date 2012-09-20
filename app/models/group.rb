class Group < ActiveRecord::Base
  attr_accessible :name, :user_id, :group_type_id, :description, :restrictions, :meeting_day, :meeting_time
  belongs_to :user
  belongs_to :group_type
  has_and_belongs_to_many :people, :uniq => true

  before_validation :fix_up_group_type

  validates :name, :user, :group_type, :meeting_day, :meeting_time, :presence => true

  # Returns the collection of people who are members of this group
  def members
    self.people
  end

  # Returns the collection of people who are not members of this group
  def non_members
    Person.joins("left outer join ( select * from groups_people where group_id = #{self.id} ) as gp on people.id = gp.person_id").where('gp.group_id is NULL')
  end

private
  # Because FormBuilder::select only updates group_type_id and not group_type, we need this before_validation
  # callback to sync these two in order to ensure that we pass validation.
  def fix_up_group_type
    if self.group_type.nil? and !self.group_type_id.nil?
      self.group_type = GroupType.find(self.group_type_id)
    end
  end
end

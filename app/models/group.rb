class Group < ActiveRecord::Base
  attr_accessible :name, :user_id, :group_type_id, :meeting_day, :meeting_time
  belongs_to :user
  has_one :group_type

  before_save :fix_up_group_type

  validates :name, :user, :group_type, :meeting_day, :meeting_time, :presence => true

private
  def fix_up_group_type
#    if self.group_type.nil? and !self.group_type_id.nil?
      self.group_type = GroupType.find(self.group_type_id)
#    end
  end
end

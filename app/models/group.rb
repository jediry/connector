class Group < ActiveRecord::Base
  attr_accessible :name, :user_id, :group_type_id, :description, :restrictions, :meeting_day, :meeting_time
  belongs_to :user
  belongs_to :group_type

  before_validation :fix_up_group_type

  validates :name, :user, :group_type, :meeting_day, :meeting_time, :presence => true

private
  # Because FormBuilder::select only updates group_type_id and not group_type, we need this before_validation
  # callback to sync these two in order to ensure that we pass validation.
  def fix_up_group_type
    if self.group_type.nil? and !self.group_type_id.nil?
      self.group_type = GroupType.find(self.group_type_id)
    end
  end
end

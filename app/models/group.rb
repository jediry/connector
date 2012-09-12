class Group < ActiveRecord::Base
  attr_accessible :name, :user_id, :meeting_day, :meeting_time
  belongs_to :user

  validates :name, :user, :meeting_day, :meeting_time, :presence => true
end

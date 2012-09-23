class Note < ActiveRecord::Base
  attr_accessible :content, :user

  belongs_to :task
  belongs_to :user

  validates :content, :presence => true
  validates :user, :presence => true

end

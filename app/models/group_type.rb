class GroupType < ActiveRecord::Base
  attr_accessible :description
  has_many :groups

  validates :description, :presence => true
end

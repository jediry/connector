class GroupType < ActiveRecord::Base
  attr_accessible :description

  default_scope order(:description)
  has_many :groups

  validates :description, :presence => true
end

class Region < ActiveRecord::Base
  attr_accessible :name

  has_many :groups

  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
end

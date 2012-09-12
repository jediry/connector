class Person < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :address_attributes
  has_one :address, :dependent => :destroy

  accepts_nested_attributes_for :address

  validates :name, :presence => true
  validates :phone, :format => { :with => /^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$/ }
  validates :email, :format => { :with => /^[0-9a-z][0-9a-z.-]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z]$/xi }
end

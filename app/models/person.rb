class Person < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :address_attributes
  has_one :address, :dependent => :destroy

  accepts_nested_attributes_for :address, :allow_destroy => true

  before_validation :strip_phone_nonnumeric

  validates :name, :presence => true
  validates :phone, :length => { :minimum => 10 }
  validates :email, :format => { :with => /^[0-9a-z][0-9a-z.-]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z]$/xi }

private
  def strip_phone_nonnumeric
    if !self.phone.nil?
      self.phone = self.phone.gsub(/[^0-9]/, '')
    end
  end
end

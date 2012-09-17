class Address < ActiveRecord::Base
  attr_accessible :city, :detail, :state, :street, :zip
  belongs_to :person

  validates :street, :city, :state, :zip, :presence => true
  validates :state, :inclusion => { :in => state_abbreviations }
  validates :zip, :format => { :with => /^[0-9]{5}(-[0-9]{4})?$/, :message => "%{value} is not a valid zip code" }
end

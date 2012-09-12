class Address < ActiveRecord::Base
  attr_accessible :city, :detail, :state, :street, :zip
  belongs_to :person

  validates :street, :city, :state, :zip, :presence => true
  validates :state, :inclusion => { :in => %w( AL AK AZ AS CA CO CN DE FL GA HI ID IL IN IA KS KY LA ME MA MS MI MN MS MO MT NB NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY ) }
  validates :zip, :format => { :with => /^[0-9]{5}(-[0-9]{4})?$/, :message => "%{value} is not a valid zip code" }
end

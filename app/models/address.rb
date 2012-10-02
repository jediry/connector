include ApplicationHelper

class Address < ActiveRecord::Base
  attr_accessible :city, :detail, :state, :street, :zip
  belongs_to :person

  validates :street, :city, :state, :zip, :presence => true
  validates :state, :inclusion => { :in => state_abbreviations }
  validates :zip, :format => { :with => /^[0-9]{5}(-[0-9]{4})?$/, :message => "%{value} is not a valid zip code" }

  # Static method to sanitze an attributes hash destined for update_attributes
  def self.sanitize_attributes(address_attributes)
    # Please delete me if I'm entirely nil
    return !address_attributes.nil? &&
            address_attributes[:street].blank? &&
            address_attributes[:detail].blank? &&
            address_attributes[:city].blank? &&
            address_attributes[:state].blank? &&
            address_attributes[:zip].blank?
  end
end

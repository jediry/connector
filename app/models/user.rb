class User < ActiveRecord::Base
  self.primary_key = :person_id

  attr_accessible :username, :password, :password_confirmation, :active, :admin, :person_attributes
  belongs_to :person, :dependent => :destroy
  has_many :groups
  has_secure_password

  # Save usernames as all lower-case, to ensure that the uniqueness constraint
  # is enforced regardless of whether the database cares about case
  before_save { |user| user.username = username.downcase }
  before_save :create_remember_token

  accepts_nested_attributes_for :person

  validates :person, :presence => true
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :length => { :minimum => 4 }
  validates :password_confirmation, :presence => true

  def name
    self.person.name
  end

private
  # Create a random token for allowing the user's browser to "remember me"
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end

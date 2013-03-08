class User < ActiveRecord::Base
  self.primary_key = :person_id

  attr_accessible :username, :password, :password_confirmation, :must_change_password, :welcome_email_sent, :remember_token, :active, :admin, :person_attributes
  belongs_to :person, :dependent => :destroy
  has_many :groups
  has_many :group_memberships, :foreign_key => :person_id
  has_many :tasks, :through => :group_memberships
  has_secure_password

  # Returns the collection of tasks assigned to this user that are currently in-progress
  def in_progress_tasks
    Task.joins('INNER JOIN group_memberships ON tasks.contact_id = group_memberships.id').joins('INNER JOIN task_statuses ON tasks.task_status_id = task_statuses.id').where('group_memberships.person_id' => id, 'task_statuses.finish' => false).order('created_at DESC')
  end

  def tasks
    super.order('created_at DESC')
  end

  # Save usernames as all lower-case, to ensure that the uniqueness constraint
  # is enforced regardless of whether the database cares about case
  before_save { |user| user.username = username.downcase }
  before_save :create_remember_token

  accepts_nested_attributes_for :person

  validates :person, :presence => true
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
  validate :has_email
#  validates :password, :length => { :minimum => 4 }
#  validates :password_confirmation, :presence => true

  def id
    self.person_id
  end

  def name
    self.person.name
  end

  def phone
    self.person.phone
  end

  def email
    self.person.email
  end

  def address
    self.person.address
  end

  def member?
    self.person.member?
  end

  # Build objects for any missing associations
  def build_if_missing
    if self.person.nil?
      self.build_person
    end
    self.person.build_if_missing
  end

  # Static method to sanitze an attributes hash destined for update_attributes
  def self.sanitize_attributes(user_attributes)
    if !user_attributes.nil?
      Person.sanitize_attributes user_attributes[:person_attributes]
    end
    return false # Don't delete me
  end

private
  # Create a random token for allowing the user's browser to "remember me"
  def create_remember_token
    if self.remember_token.nil?
      self.remember_token = SecureRandom.urlsafe_base64
    end
  end

  def has_email
    if self.person.email.blank?
      errors.add(:email, 'In order to make this person a user, the email address must not be blank.')
    end
  end
end

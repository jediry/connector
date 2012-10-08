class User < ActiveRecord::Base
  self.primary_key = :person_id

  attr_accessible :username, :password, :password_confirmation, :must_change_password, :active, :admin, :person_attributes
  belongs_to :person, :dependent => :destroy
  has_many :groups
  has_many :tasks
  has_secure_password

  # Returns the collection of tasks assigned to this user that are currently in-progress
  def in_progress_tasks
    Task.joins('inner join task_statuses on tasks.task_status_id = task_statuses.id').where('tasks.user_id' => id, 'task_statuses.finish' => false).order('created_at DESC')
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
#  validates :password, :length => { :minimum => 4 }
#  validates :password_confirmation, :presence => true

  def name
    self.person.name
  end

  def id
    self.person_id
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

end

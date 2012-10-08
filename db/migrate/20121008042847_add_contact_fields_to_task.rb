class AddContactFieldsToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :last_contact_attempt_made_at, :datetime
    add_column :tasks, :attempt_next_contact_by, :datetime
    add_column :tasks, :consecutive_failed_contact_attempts, :integer, :null => false, :default => 0
  end
end

class AddWelcomeEmailSentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_email_sent, :boolean, :null => false, :default => false
  end
end

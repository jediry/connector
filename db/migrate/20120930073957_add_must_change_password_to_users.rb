class AddMustChangePasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :must_change_password, :boolean, :null => false, :default => false
  end
end

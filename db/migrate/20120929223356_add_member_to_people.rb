class AddMemberToPeople < ActiveRecord::Migration
  def change
    add_column :people, :member, :boolean, :null => false, :default => false
  end
end

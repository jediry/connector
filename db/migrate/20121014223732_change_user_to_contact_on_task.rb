class ChangeUserToContactOnTask < ActiveRecord::Migration
  def up
    rename_column :tasks, :user_id, :contact_id

    # Right now, the 'contact_id' column still references the user's id, not the id of the group membership
    Task.reset_column_information
    Task.all.each do |t|
      gm = GroupMembership.find_by_person_id(t.contact_id)
      t.update_attributes({:contact_id => gm.id})
    end
  end

  def down
    # Put back the user_id the way it was
    #execute 'UPDATE tasks t J
    rename_column :tasks, :contact_id, :user_id
  end
end

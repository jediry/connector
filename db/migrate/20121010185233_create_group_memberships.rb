class CreateGroupMemberships < ActiveRecord::Migration
  def up
    rename_table :groups_people, :group_memberships
    add_column :group_memberships, :id, :primary_key
    add_column :group_memberships, :leader, :boolean, :null => false, :default => false
    add_column :group_memberships, :host, :boolean, :null => false, :default => false
    add_column :group_memberships, :contact, :boolean, :null => false, :default => false

    # Locate the current contact person for each group, and add him/her to the group as a contact
    say_with_time 'Converting old contact user over to leader/contact/host roles' do
      GroupMembership.reset_column_information
      Group.all.each do |g|
        user_membership = g.group_memberships.find_by_person_id(g.user_id)
        if user_membership.nil?
          user_membership = g.group_memberships.build :person_id => g.user_id, :group_id => g.id
        end
        user_membership.leader = true
        user_membership.contact = true
        user_membership.host = true
        user_membership.save
      end
    end

    # Now throw out the old 'user' column in the group table
    remove_column :groups, :user_id
  end

  def down
    add_column :groups, :user_id, :integer

    say_with_time 'Converting contact role to old-style group user' do
      Group.reset_column_information
      GroupMembership.where(:contact => true).each do |m|
        m.group.update_attributes({ :user_id => m.person_id })
      end
    end

    remove_column :group_memberships, :id
    remove_column :group_memberships, :leader
    remove_column :group_memberships, :host
    remove_column :group_memberships, :contact
    rename_table :group_memberships, :groups_people
  end
end

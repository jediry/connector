class FixUpMissingUsers < ActiveRecord::Migration
  def up
#    Task.all.each do |t|
#      if t.user.nil?
#        t.destroy
#      end
#    end

    GroupMembership.all.each do |gm|
      if ( gm.leader? || gm.contact? ) && gm.person.user.nil?
        say "Creating missing user account for person #{gm.person.name}" do
          gm.person.create_user
        end
      end
    end
  end

  def down
  end
end

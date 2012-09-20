class GroupsPeople < ActiveRecord::Migration
  def change
    create_table :groups_people, :id => false do |t|
      t.references :group, :null => false
      t.references :person, :null => false
    end

    add_index :groups_people, [:group_id, :person_id], :unique => true
  end
end

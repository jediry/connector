class CreateGroupTypes < ActiveRecord::Migration
  def change
    create_table :group_types do |t|
      t.string :description

      t.timestamps
    end

    # For now, just hard-code these
    GroupType.create :description => 'Community Group'
    GroupType.create :description => 'Service Team'
  end
end

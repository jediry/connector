class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :user
      t.references :group_type
      t.integer :meeting_day
      t.time :meeting_time

      t.timestamps
    end
  end
end

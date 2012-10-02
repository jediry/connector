class AddActiveToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :active, :boolean, :null => false, :default => true
  end
end

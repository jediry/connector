class AddDescriptionAndRestrictionsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :description, :text
    add_column :groups, :restrictions, :text
  end
end

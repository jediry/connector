class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name, :null => false

      t.timestamps
    end

    add_index :regions, :name, :unique => true

    change_table :groups do |t|
      t.references :region
    end
  end
end

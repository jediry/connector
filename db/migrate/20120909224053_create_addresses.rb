class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :detail
      t.string :city
      t.string :state
      t.string :zip
      t.references :person

      t.timestamps
    end
    add_index :addresses, :person_id
  end
end

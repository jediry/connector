class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => false do |t|
      t.references :person
      t.string :username
      t.string :password_digest
      t.string :remember_token
      t.boolean :active, :default => true
      t.boolean :admin

      t.timestamps
    end
    add_index :users, :person_id
    add_index :users, :username, :unique => true
    add_index :users, :remember_token
  end
end

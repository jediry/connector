class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => :false do |t|
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

    # Create a default administrative user, so we can log in to begin with
    User.create :username => 'admin',
                :password => 'admin',
                :password_confirmation => 'admin',
                :active => true,
                :admin => true,
                :person_attributes => {
                    :name => 'Administrator',
                    :email => 'admin@example.com',
                    :phone => '(000) 000-0000'
                }
  end
end

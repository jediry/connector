# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

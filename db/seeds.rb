# This file should contain all the record creation needed to seed the database wi   th its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if you want to take advantage of CanCanCan access check policy on VIEW by nullable active record collection (e.g. user_holder.treatments, user_holder.medications),
# - then you need to initialize one of the instance here to make sure the collections are not nullable.
test_user = User.create!(first_name: 'TestUser', last_name: '01', email: 'testuser01@testuser.com', password: 'password', password_confirmation: 'password', is_doctor: false, role: 'patient')
test_user_holder = UserHolder.create!(first_name: test_user.first_name, last_name: test_user.last_name, email: test_user.email, user_id: test_user.id)
test_profile = Profile.create!(first_name: test_user_holder.first_name, last_name: test_user_holder.last_name, email: test_user_holder.email, whatsapp: '6198089569', user_holder_id: test_user_holder.id)
test_medication = Medication.create!(provider: "Test Provider", directions: "Test Directions", days: "7 days", description: "Test Description", user_holder_id: test_user_holder.id)
test_treatment = Treatment.create!(provider: "Test Provider", location: "Test location", status: "On going", name: "Test Treatment Name", description: "Test Description", user_holder_id: test_user_holder.id)

# This is the guest user for fall-back.
# If you want to support fall back for non-log-in user for your Resource, initialize it.
guest_user = User.create!(first_name: 'Guest', last_name: 'User', email: 'guest@guest.com', password: 'password', password_confirmation: 'password', is_doctor: false, role: 'guest')
guest_user_holder = UserHolder.create!(first_name: guest_user.first_name, last_name: guest_user.last_name, email: guest_user.email, user_id: guest_user.id)
guest_profile = Profile.create!(first_name: guest_user.first_name, last_name: guest_user.last_name, email: guest_user.email, whatsapp: '6198089569', user_holder_id: guest_user_holder.id)


users = [{:role => 'patient', :first_name => "Peter", :last_name => "Pei", :email => "ppei@gmail.com",  :whatsapp=> "6198089569", :password => "password", :password_confirmation => "password"},
         {:role => 'patient', :first_name => "Tom", :last_name => "Brady", :email => "tombb@gmail.com",  :whatsapp=> "6198089569", :password => "password", :password_confirmation => "password"},
         {:role => 'patient', :first_name => "Steven", :last_name => "Jobs", :email => "stevenjb@gmail.com",  :whatsapp=> "6198089569", :password => "password", :password_confirmation => "password"},
         {:role => 'doctor', :first_name => "Bill", :last_name => "Gates", :email => "bliigb@gmail.com",  :whatsapp=> "6198089569", :password => "password", :password_confirmation => "password", :is_doctor => true},
         {:role => 'doctor', :first_name => "Tom", :last_name => "Cool", :email => "tomcool2011@gmail.com",  :whatsapp=> "6198089569", :password => "password", :password_confirmation => "password", :is_doctor => true},
         {:role => 'patient', :first_name => "Test", :last_name => "Pat", :email => "tp1@gmail.com",  :whatsapp=> "6198089569", :password => "password", :password_confirmation => "password", :is_doctor => false},

]

users.each do |current_user|
  new_user = User.new(role: current_user[:role], first_name: current_user[:first_name], last_name: current_user[:last_name], email: current_user[:email], password: current_user[:password], password_confirmation: current_user[:password_confirmation], is_doctor: current_user[:is_doctor])
  # new_user.skip_confirmation!
  new_user.save!
  new_user_holder = UserHolder.create!(first_name: new_user.first_name,
                                  last_name: new_user.last_name,
                                  email: new_user.email,
                                  user_id: new_user.id)
  newprofile = Profile.create!(first_name: new_user.first_name,
                              last_name: new_user.last_name,
                              email: new_user.email,
                              whatsapp: current_user[:whatsapp],
                              user_holder_id: new_user_holder.id)
end

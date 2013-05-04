require 'ffaker'

namespace :db do
  desc "Erase and fill database"
  task :populate_users => :environment do
  	ActiveRecord::Base.transaction do
  		20.times do
      	User.create!(:name => Faker::Name.name, :email => Faker::Internet.email, :password => "password")
    	end
    end

  end

end
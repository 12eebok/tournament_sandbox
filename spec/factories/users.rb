# Read about factories at https://github.com/thoughtbot/factory_girl
require 'ffaker'

FactoryGirl.define do

	sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :user do
    name { Faker::Name.name }
    email
    password 'password'
  end
end

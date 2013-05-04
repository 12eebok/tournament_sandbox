require 'spec_helper'

describe Registration do

	before(:each) do
		@competition = FactoryGirl.create(:competition, :ends_at => Time.now + 1.day)
		@users = 10.times.map {FactoryGirl.create(:user)}
	end

	it "should create a new instance given valid attributes" do
    FactoryGirl.create(:registration)
  end

	it "fails when a user attempts to register twice" do
		expect{
			2.times do
				FactoryGirl.create(:registration, :competition => @competition, :registerable => @users[0])
			end
		}.to raise_error(ActiveRecord::RecordInvalid)
	end

	it "fails when two teams register with the same user" do
		teams = 2.times.map {FactoryGirl.create(:team, :leader => @users[0])}
		expect{
			2.times do |i|
				FactoryGirl.create(:registration, :competition => @competition, :registerable => teams[i])
			end
		}.to raise_error(ActiveRecord::RecordInvalid)
	end

	it "delete withdraws the entrant instead" do
		registration = FactoryGirl.create(:registration, :competition => @competition)
		expect{
			registration.destroy
		}.to change{registration.disqualified}.from(false).to(true)
	end

	it "delete raises an error if registration has already ended" do
		registration = FactoryGirl.create(:registration)
		expect{
			registration.destroy
		}.to raise_error("Registration has already ended - it's too late to withdraw.")
	end

	describe "type validation" do

		it "fails if it's a solo registration on a team-based competition" do
			user = FactoryGirl.create(:user)
			registration = FactoryGirl.create(:team_registration)
			expect{registration.assign_to(user)}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it "fails if it's a team registration on a solo competition" do
			team = FactoryGirl.create(:team)
			registration = FactoryGirl.create(:registration)
			expect{registration.assign_to(team)}.to raise_error(ActiveRecord::RecordInvalid)
		end

	end

end

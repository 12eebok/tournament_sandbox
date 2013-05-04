require 'spec_helper'

describe Competition do

  it "creates a new instance given valid attributes" do
    FactoryGirl.create(:competition)
  end

  it "fails if a game type is not assigned" do
  	FactoryGirl.build(:competition, :game => nil).should_not be_valid
  end

  it "is invalid if end date is greater that parent tournament's end date" do
		FactoryGirl.build(:competition, :starts_at => "2013-04-22 12:11:14",
			                :ends_at => "2053-04-22 12:11:14").should_not be_valid
	end

 it "is invalid if start date is less than parent tournament's start date" do
		FactoryGirl.build(:competition, :starts_at => "1900-04-22 12:11:14",
                      :ends_at => "2013-04-22 12:11:14").should_not be_valid
	end

end

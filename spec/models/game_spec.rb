require 'spec_helper'

describe Game do

	it "create a new instance given valid attributes" do
    FactoryGirl.create(:game)
  end

  it "the required_field listing should coincide with editable match fields" do
    FactoryGirl.build(:game, :required_fields => "foo,bar").should_not be_valid
  end

	describe "team validations" do

		it "requires a min/max number of entries if team based is set to true" do
			FactoryGirl.build(:game, :team_based => true, :min_entries => nil, :max_entries => nil).should_not be_valid
		end

		it "requires a positive number of min/max entries" do
			FactoryGirl.build(:game, :team_based => true, :min_entries => -1, :max_entries => -1).should_not be_valid
		end

		it "requires min entries to be less than or equal to max entries" do
			FactoryGirl.build(:game, :team_based => true, :min_entries => 5, :max_entries => 1).should_not be_valid
		end

	end

end

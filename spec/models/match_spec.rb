require 'spec_helper'

describe Match do

  it "expects winner to be a participant of the matchup or nil" do
  	FactoryGirl.build(:match, :winner_id => 9001).should_not be_valid
	end

end

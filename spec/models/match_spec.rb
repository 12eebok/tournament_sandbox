require 'spec_helper'

describe Match do

  it "expects winner to be a participant of the matchup (knockout or round robin)" do
  	FactoryGirl.build(:knockout_match, :winner_id => 9001).should_not be_valid
	end

	it "is invalid if it contains a contestant that was eliminated in prior rounds (knockout)" do
		# manually setting counter cache below because FactoryGirl is garbage
		competition = FactoryGirl.create(:knockout_competition, :registrations_count => 4)
		4.times do
			user = FactoryGirl.create(:user)
			competition.registrations.build(:registerable_id => user.id, :registerable_type => "User").save

		end
		competition.build_matches
		# eliminate the player in the first match
		Match.first.update_attribute(:winner_id, Match.first.opponent_id)
		match = Match.last
		# try re-assigning the previously eliminated player as a player in the last match
		match.player_id = Match.first.player_id
		match.should_not be_valid
	end

end

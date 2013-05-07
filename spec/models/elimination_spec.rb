require 'spec_helper'

describe Elimination do

	# Build match listing for knockout competition
	before(:each) do
		# Manually setting counter cache below because FactoryGirl is garbage
		@competition = FactoryGirl.create(:knockout_competition, :registrations_count => 4)
		4.times do
			user = FactoryGirl.create(:user)
			@competition.registrations.build(:registerable_id => user.id, :registerable_type => "User").save
		end
		@competition.build_matches
	end


	it "is invalid if it contains a contestant that was eliminated in prior rounds" do
		# eliminate the player in the first match
		elimination1 = Elimination.first
		elimination1.update_attribute(:winner_id, elimination1.opponent_id)
		elimination2 = Elimination.last
		# try re-assigning the previously eliminated player as a player in the last match
		elimination2.player_id = elimination1.player_id
		elimination2.should_not be_valid
	end

	it "is invalid if it contestant fills the role of both player and opponent" do
		@competition.eliminations.build(:player_id => 1, :opponent_id => 1).should_not be_valid
	end

end

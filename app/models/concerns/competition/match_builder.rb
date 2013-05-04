class Competition
  module MatchBuilder
    extend ActiveSupport::Concern

	  def build_matches
	  	if Time.now > ends_at
		    #check the format of the competition
		    #"Knockout", "Round Robin", "Other"
		    clear_matches
		    case format
		      when "Knockout"
		        rounds = knockout
		      when "Round Robin"
		        rounds = round_robin
		      else
		        rounds = non_elimination
		    end
		    rounds.each do |round|
	      	round.each do |match|
	        	matches.build(match).save!
	        end
	      end
			else
				raise "Competition registration is still open - #{ApplicationController.helpers.distance_of_time_in_words(Time.now, ends_at)} to go."
			end
		end

		def knockout
		  rounds = []
		  registrants_pool = registration_ids
		  # Byes need to be added if the registrations count is not devisible by two
		  unless registrations_count & (registrations_count - 1) == 0
		  	byes = (2 ** required_rounds) - registrations_count
		  	bye_pool = byes.times.map {registrants_pool.delete_at(rand(registrants_pool.length))}
		  	# The following two loops correspond to rounds 1 and 2 respectively, there will always
		  	# be at minimum two rounds if the registration count is not devisible by two
				rounds << (registrants_pool.length / 2).times.map do
					{
						:round => 1,
						:player_id => registrants_pool.delete_at(rand(registrants_pool.length)),
					 	:opponent_id => registrants_pool.delete_at(rand(registrants_pool.length))
					}
				end
				# Some byes need to have an open opponent_id slot, the rest need to be paired up with one-another
				# this loop is setup in such a way that player_id slots are prioritized so that there are opponent_id
				# slots available for the players that weren't eliminated in round 1
				rounds << ((byes + ((registrations_count - byes))/2) / 2).times.map do
					{
						:round => 2,
						:player_id => bye_pool.delete_at(rand(bye_pool.length)),
						:opponent_id => bye_pool.length > rounds[0].length ?  bye_pool.delete_at(rand(bye_pool.length)) : nil
					}
				end
				# This final loop handles any remaining rounds after the 2nd round - at this point the player numbers have been
				# made devisible by two thanks to the byes introduced in round 2. We can now confidently loop through all remaining
				# rounds.
				rounds_remaining = required_rounds - rounds.size
				rounds_remaining.times do |round|
					rounds << (rounds.last.size / 2).times.map {{:round => (round + 1) + 2, :player_id => nil, :opponent_id => nil}}
				end
		  else
		  	round_i = registrations_count
			  (required_rounds).times do |i|

				  rounds << (round_i /= 2).times.map do |x|
				  	{
				  		:round => i + 1,
				    	:player_id => registrants_pool.delete_at(rand(registrants_pool.length)),
				    	:opponent_id => registrants_pool.delete_at(rand(registrants_pool.length))
				    }
				   end
			  end
			end
			rounds
		end

	  def round_robin
	    #TO-DO add a ghost if registrants.count%2 > 0
	    games = (1...registrants.size).map do |r|
	        t = registrants.dup
	        (0...(registrants.size/2)).map do |_|
	          [t.shift,t.delete_at(-(r % t.size + (r >= t.size * 2 ? 1 : 0)))]
	        end
	      end
	    games.each_with_index do |game, index|
	      games[index].each do |player|
	        match = self.matches.build(:round => index + 1, :register_id => player[0].id, :register_id_2 => player[1].id)
	        match.save
	      end
	    end
	  end

	  #generates non elimination matches
	  def non_elimination
	    3.times do |n|
	      registers.each do |registrant|
	        matches.build(:round => n + 1, :register_id => registrant.id).save
	      end
	    end
	  end

	  def clear_matches
	    if matches.any?
	      matches.each do |match|
	      	match.delete
	      end
	      update_attribute(:publish_at, nil)
	      registrations.update_all(:place => nil, :score => nil)
	    end
	  end

	end
end
module CompetitionsHelper

	# Render strategy for Competition results entry
	def entry_template(competition)
		case competition.format
	  	when "Elimination"
	    	render :template => "eliminations/entry", :locals => { :competition => competition }
	  	when "Round Robin"
		 	when "Other"
		end
	end

	# Render strategy for Competition results
	def results_template(competition)
		case competition.format
	  	when "Elimination"
	    	render :template => "eliminations/results", :locals => { :competition => competition }
	  	when "Round Robin"
		 	when "Other"
		end
	end

end

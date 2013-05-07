module CompetitionsHelper

	# Render strategy for Competition results entry
	def entry_template(competition)
		case @competition.format
	  	when "Elimination"
	    	render :template => "eliminations/entry", :locals => { :competition => competition }
	  	when "Round Robin"
		 	when "Other"
		end
	end

end

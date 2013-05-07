class Competition
  module MatchGrapher
    extend ActiveSupport::Concern

    def generate_graph
    	competition = self
    	# Ensure that graph is only generated if matches have been setup
    	if eliminations.any? #TO-DO extend this if-statement to ensure that the competition is completed maybe?
				path = "#{Rails.root}/public/competitions/#{competition.id}"
				FileUtils.mkdir(path) unless File.exists? path
				require 'graph'
				digraph do
					matches = competition.eliminations
				  boxes
				  label(competition.name)
				  orient "LR"
				  colour = 0
					colorscheme(:pubu, 8)
				  graph_attribs << "labelloc=\"t\""
					edge_attribs << ["arrowhead=none", "arrowtail=none", "style=bold"]
				  node_attribs << filled

					# Node & edge setup
					matches.each do |match|
						unless match.winner_id.nil?
							node(match.id).label "#{match.label}"
							edge match.id, match.edge.id unless match.edge.nil?
						end
					end

					# Assigns up to 8 rounds a unique colour
					matches.group_by(&:round).map do |round, round_matches|
						colour += 1 unless colour >= 8
						puts "Adding colours for round #{round}"
						round_matches.each do |match|
						unless match.winner_id.nil?
							eval("c#{colour}") << node(match.id)
							puts "\tNode #{match.id} should be #{colour}"
							end
						end
					end
					#save as svg and fallback png
				  save "#{path}/graph", "svg"
				  save "#{path}/graph", "png"
				end
			else
				raise "Missing data - enter in match data to proceed."
			end
		end


		def cycle(first_value, *values)
		  if (values.last.instance_of? Hash)
		    params = values.pop
		    name = params[:name]
		  else
		    name = "default"
		  end
		  values.unshift(first_value)

		  cycle = get_cycle(name)
		  unless cycle && cycle.values == values
		    cycle = set_cycle(name, Cycle.new(*values))
		  end
		  cycle.to_s
		end

  end
end
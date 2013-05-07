class Elimination < Match

  validate :single_player_participation_per_round, :single_opponent_participation_per_round
 	validate :player_not_eliminated, :if => :player_id
  validate :opponent_not_eliminated, :if => :opponent_id
  validate :prior_matches_resolved

  # This prevents accidently invalidating records in later rounds
  def prior_matches_resolved
    if (player_id_changed? || opponent_id_changed?) && competition.matches.where("round < ? and winner_id IS NULL", round).any?
      errors.add(:base, "Resolve the winners of any previous rounds before assigning contestants to this one.")
    end
  end

  # Retrieve the ensuing match for graphing
  def edge
    competition.matches.where("(player_id = ? OR opponent_id = ?) AND round = ?", winner_id, winner_id, round + 1).first
  end

  def single_player_participation_per_round
    if competition.matches.where("(player_id = ? OR opponent_id = ?) AND round = ? AND id != ?", player_id, player_id, round, id).any?
      errors.add(:player_id, "has already participated in this round")
    end
  end

  def single_opponent_participation_per_round
    if competition.matches.where("(player_id = ? OR opponent_id = ?) AND round = ? AND id != ?", opponent_id, opponent_id, round, id).any?
      errors.add(:opponent_id, "has already participated in this round")
    end
  end

  def player_not_eliminated
    if competition.format == "Elimination"
      if competition.eliminated.map(&:id).include? player.id || player.disqualified?
        errors.add(:player_id, "has already been eliminated from this competition")
      end
    end
  end

  def opponent_not_eliminated
    if competition.format == "Elimination"
      if competition.eliminated.map(&:id).include? opponent.id || opponent.disqualified?
        errors.add(:opponent_id, "has already been eliminated from this competition")
      end
    end
  end

  # Used for graphs, see Competition::MatchGrapher
  def label
  	if !player.nil? && !opponent.nil?
  		"#{player_name}\n#{opponent_name}"
  	elsif !player.nil? && opponent.nil?
  		"#{player_name}\n-----"
  	else
  		"----\n----"
  	end
  end

end

class Match < ActiveRecord::Base

  belongs_to :competition
  belongs_to :player, :class_name => "Registration"
  belongs_to :opponent, :class_name => "Registration"
  belongs_to :winner, :class_name => "Registration"

  attr_accessible :competition_id, :milliseconds_elapsed, :opponent_id, :player_id, :round, :winner_id

  delegate :name, :to => :player, :prefix => true, :allow_nil => true
  delegate :name, :to => :opponent, :prefix => true, :allow_nil => true
  delegate :name, :to => :winner, :prefix => true, :allow_nil => true
  delegate :name, :to => :competition, :prefix => true

  validate :single_player_participation_per_round, :single_opponent_participation_per_round
  validate :winner_id_corresponds_to_contestant, :if => :winner_id
  validate :player_not_eliminated, :if => :player_id
  validate :opponent_not_eliminated, :if => :opponent_id
  validate :opponent_different_from_player, :if => lambda { |r| r.player_id && r.opponent_id }
  validate :prior_matches_resolved
  # validate :eliminated_player_does_not_proceed

  # This prevents accidently invalidating records in later rounds
  def prior_matches_resolved
    if winner_id_changed? && competition.matches.where("round < ? and winner_id IS NULL", round).any?
      errors.add(:base, "Assign a winner to any previous rounds before trying to assign a winner to this one.")
    elsif (player_id_changed? || opponent_id_changed?) && (round >= 3 && competition.matches.where("round < ? and winner_id IS NULL", round).any?)
      errors.add(:base, "Resolve the winners of any previous rounds before assigning contestants to this one.")
    end
  end

  # Retrieve the ensuing match for graphing
  def edge
    competition.matches.where("(player_id = ? OR opponent_id = ?) AND round = ?", winner_id, winner_id, round + 1).first
  end

  # Prevents accidently invalidating records in subsequent rounds by updating records in previous ones
  # def eliminated_player_does_not_proceed
  #   if winner_id_changed? && (competition.matches.where("round > ? and player_id = ? or opponent_id = ?", round, player_id, player_id).any? || competition.matches.where("round > ? and player_id = ? or opponent_id = ?", round, opponent_id, opponent_id).any?)
  #     errors.add(:base, "Eliminated player is already assigned to subsequent rounds, please change those first.")
  #   end
  # end

  # Might need to modify this to work with round robin
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

  def opponent_different_from_player
    errors.add(:opponent, "must be the different from the first contestant") if opponent_id == player_id
  end

  # Only executed if winner_id is entered and the competition is in versus format
  def winner_id_corresponds_to_contestant
    unless [player_id, opponent_id].include?(winner_id) && ["Knockout", "Round Robin"].include?(competition.format)
  		errors.add(:winner_id, "must be a participant of this matchup.")
  	end
  end

  def player_not_eliminated
    if competition.format == "Knockout"
      if competition.eliminated.map(&:id).include? player.id || player.disqualified?
        errors.add(:player_id, "has already been eliminated from this competition")
      end
    end
  end

  def opponent_not_eliminated
    if competition.format == "Knockout"
      if competition.eliminated.map(&:id).include? opponent.id || opponent.disqualified?
        errors.add(:opponent_id, "has already been eliminated from this competition")
      end
    end
  end

  def self.editable_field_names
  	[:player_id, :opponent_id, :winner_id,:milliseconds_elapsed]
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

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

  validate :winner_id_corresponds_to_contestant, :if => :winner_id
  validate :opponent_different_from_player, :if => lambda { |r| r.player_id && r.opponent_id }

  after_save :print_graph, :if => :winner_id

  def print_graph
    competition.generate_graph
  end


  def opponent_different_from_player
    errors.add(:opponent, "must be the different from the first contestant") if opponent_id == player_id
  end

  def winner_id_corresponds_to_contestant
    unless [player_id, opponent_id].include?(winner_id)
  		errors.add(:winner_id, "must be a participant of this matchup.")
  	end
  end

  def self.editable_field_names
  	[:player_id, :opponent_id, :winner_id,:milliseconds_elapsed]
  end

end

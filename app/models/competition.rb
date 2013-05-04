class Competition < ActiveRecord::Base

  include MatchBuilder
  include MatchGrapher

  has_many :matches
  has_many :registrations
  belongs_to :tournament
  belongs_to :game

  attr_accessible :description, :ends_at, :name, :publish_at, :starts_at, :submission_mask, :tournament_id, :game_id, :registrations_count

  validates :game_id, :presence => true
  validate :end_time_less_than_tournament_end_time, :start_time_greater_than_tournament_start_time

  delegate :team_based, :format, :to => :game

  def teams
	  Team.where(:id => registrations.where(:registerable_type => Team.name).map(&:registerable_id))
	end

  def players
  	User.where(:id => registrations.where(:registerable_type => User.name).map(&:registerable_id))
  end

  #knockout competition

  def remaining
    eliminated.any? ? registrations.where("id not in (?)",eliminated.map(&:id)) : registrations
  end

  def eliminated
    registrations.joins(:matches).where("registrations.id != winner_id") + registrations.joins(:matches_contending).where("registrations.id != winner_id")
  end

  def graph_url
    "/competitions/#{id}/graph.svg"
  end

  private

	  def end_time_less_than_tournament_end_time
	    errors.add(:ends_at, "can't be greater than tournaments end time") if tournament.ends_at < ends_at
	  end

	  def start_time_greater_than_tournament_start_time
	    errors.add(:starts_at, "can't be less than tournaments start time") if tournament.starts_at > starts_at
	  end

    def required_rounds
      Math.log2(registrations_count).ceil
    end

end

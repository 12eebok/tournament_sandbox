class Competition < ActiveRecord::Base

  include MatchBuilder
  include MatchGrapher

  has_many :matches
  has_many :eliminations
  has_many :registrations
  belongs_to :tournament
  belongs_to :game

  attr_accessible :description, :ends_at, :name, :publish_at, :starts_at, :submission_mask, :tournament_id, :game_id, :registrations_count

  validates :game_id, :ends_at, :starts_at, :presence => true
  validate :end_time_less_than_tournament_end_time, :if => :ends_at
  validate :start_time_greater_than_tournament_start_time, :if => :starts_at?

  delegate :team_based, :format, :to => :game

  def ended?
    ends_at < Time.now
  end

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
    File.exist?("public" + "/competitions/#{id}/graph.svg") ? "/competitions/#{id}/graph.svg" : nil
  end

  def graph_fallback_url
    File.exist?("public" + "/competitions/#{id}/graph.png") ? "/competitions/#{id}/graph.png" : nil
  end

  def check_registered(user)
    registrations.where(:registerable_id => user.id, :registerable_type => user.class).any?
  end

  def rounds
    matches.group(:round).length
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

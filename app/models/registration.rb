class Registration < ActiveRecord::Base

  # For most matches there is no significance in whether a player is represented as a player or and
  # opponent (defending/contending). The primary purpose behind this is a medium for distinguishing two
  # contestants facing off against eachother  in any given match-up.
  #
  # There are, however, some exceptions. For instance, in matches where players aren't directly competing
  # against other players, e.g., time-based competitions the player role is used in preference to the opponent
  # role.
  #
  #TO-DO Possibily consider an STI interface for Matches to accommodate the different match types?

  has_many :matches, :class_name => "Match", :foreign_key => "player_id"
  has_many :matches_contending, :class_name => "Match", :foreign_key => "opponent_id"

  has_many :matches_won

  belongs_to :competition, :counter_cache => true
  belongs_to :registerable, :polymorphic => true
  attr_accessible :disqualification_reason, :disqualified, :entry_id, :place, :registerable_id, :registerable_type, :score, :competition_id

  validates :registerable_id, :uniqueness => { :scope => [:competition_id, :registerable_type], :message => "is already registered for this competition" }
  validate :team_members_uniqueness
  validate :registerable_type_should_comply_with_competition

  delegate :name, :to => :registerable

  #withdrawal is performed in place of a delete request
  before_destroy :withdraw

  def assign_to(entity)
    update_attributes!(:registerable_id => entity.id, :registerable_type => entity.class.name)
  end

  private

    def registerable_type_should_comply_with_competition
      if competition.team_based && registerable_type == "User"
        errors.add(:registerable_type, "is not a valid team.")
      elsif !competition.team_based && registerable_type == "Team"
        errors.add(:registerable_type, "is not a valid user.")
      end
    end

    def withdraw
      if Time.now < competition.ends_at
        self.update_attributes!(:disqualified => true,
                                :disqualification_reason => "Withdrew from the competition")
        false #prevent delete
      else
        raise "Registration has already ended - it's too late to withdraw."
      end
    end

    #fails if two teams register for a competition with mutual members
    def team_members_uniqueness
    	if registerable_type == "Team"
    		ids = [Team.find(registerable_id).member_ids |
    			     competition.teams.map {|team| team.member_ids}].flatten
    		errors.add(:registerable_id, "is already registered for this competition") if ids.uniq.length == ids.length
    	end
    end

end

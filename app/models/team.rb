class Team < ActiveRecord::Base

	belongs_to :leader, :class_name => "User"
	has_many :registrations, :as => :registerable
  has_and_belongs_to_many :users

  attr_accessible :leader_id, :name

  #delegate leader and users to a single call
  def member_ids
    user_ids << leader_id
  end

end

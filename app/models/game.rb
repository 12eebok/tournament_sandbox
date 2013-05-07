class Game < ActiveRecord::Base

	has_many :competitions

  attr_accessible :format, :max_entries, :min_entries, :name, :required_fields, :team_based, :rounds

  FORMATS=["Elimination", "Round Robin", "Other"]

  #lowest and highest entries ranges that can be definied
  MIN_MIN_ENTRIES = 1
  MAX_MAX_ENTRIES = 10

  validates :min_entries, :max_entries, :presence => true, :if => :team_based?
  validates :min_entries, :max_entries, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }, :allow_nil => true
  validate :min_entries_is_less_than_max_entries, :if => :team_based?
  validate :required_fields_corresponds_to_editable_field_names, :if => :required_fields



  private

	  def min_entries_is_less_than_max_entries
	    unless min_entries.nil? && max_entries.nil?
	    	errors.add(:min_entries, "should be less than or equal to max entries") if min_entries > max_entries
	    end
	  end

	  def required_fields_corresponds_to_editable_field_names
	  	errors.add(:required_fields, "contains invalid field selections") if (required_fields.split(",") - Match.editable_field_names.map {|x|x.to_s}).size > 0
		end

end

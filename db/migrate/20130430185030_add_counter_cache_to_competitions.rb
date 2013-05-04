class AddCounterCacheToCompetitions < ActiveRecord::Migration
  def up
    add_column :competitions, :registrations_count, :integer, :default => 0
    Competition.find_each do |competition|
      competition.update_attribute(:registrations_count, competition.registrations.length)
      competition.save
    end
  end

   def down
    remove_column :competitions, :registrations_count
  end
end

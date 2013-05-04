class AddGameIdToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :game_id, :integer
  end
end

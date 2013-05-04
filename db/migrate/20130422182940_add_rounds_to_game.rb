class AddRoundsToGame < ActiveRecord::Migration
  def change
    add_column :games, :rounds, :integer, :default => 1
  end
end

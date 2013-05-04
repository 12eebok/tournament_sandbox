class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :competition_id
      t.integer :round, :default => 0
      t.integer :milliseconds_elapsed, :default => 0
      t.integer :player_id
      t.integer :opponent_id

      t.timestamps
    end
  end
end

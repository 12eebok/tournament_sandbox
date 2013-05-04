class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :format
      t.string :required_fields
      t.boolean :team_based
      t.integer :min_entries
      t.integer :max_entries

      t.timestamps
    end
  end
end

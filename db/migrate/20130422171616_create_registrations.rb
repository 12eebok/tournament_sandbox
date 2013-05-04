class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :registerable_id
      t.integer :registerable_type
      t.integer :entry_id
      t.integer :place
      t.integer :score
      t.boolean :disqualified
      t.text :disqualification_reason
      t.references :competition

      t.timestamps
    end
    add_index :registrations, :competition_id
  end
end

class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :name
      t.text :description
      t.references :tournament
      t.integer :submission_mask
      t.datetime :publish_at

      t.timestamps
    end
    add_index :competitions, :tournament_id
  end
end

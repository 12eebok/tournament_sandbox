class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.text :instructions
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end

class AddWinnerIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :winner_id, :integer
  end
end

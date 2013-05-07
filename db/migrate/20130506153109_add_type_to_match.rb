class AddTypeToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :type, :string
  end
end

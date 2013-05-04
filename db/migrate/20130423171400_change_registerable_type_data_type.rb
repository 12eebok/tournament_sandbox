class ChangeRegisterableTypeDataType < ActiveRecord::Migration
  def up
  	change_column :registrations, :registerable_type, :string
  end

  def down
  	change_column :registrations, :registerable_type, :integer
  end
end

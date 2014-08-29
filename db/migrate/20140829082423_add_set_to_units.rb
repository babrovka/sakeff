class AddSetToUnits < ActiveRecord::Migration
  def change
    add_column :units, :lft, :integer
    add_column :units, :rgt, :integer
  end
end

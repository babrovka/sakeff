class AddModelFilenameToUnits < ActiveRecord::Migration
  def change
    add_column :units, :model_filename, :string
  end
end

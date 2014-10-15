class AddFileTypesToUnits < ActiveRecord::Migration
  def change
    rename_column :units, :model_filename, :filename
  end
end

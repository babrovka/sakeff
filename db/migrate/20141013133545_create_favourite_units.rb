class CreateFavouriteUnits < ActiveRecord::Migration
  def change
    create_table :favourite_units do |t|
      t.uuid :unit_id
      t.uuid :user_id

      t.timestamps
    end
  end

  def up
    add_index :favourite_units, [:unit_id, :user_id]
  end
  def down
    remove_index :favourite_units, [:unit_id, :user_id]
  end
end

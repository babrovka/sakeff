class ChangePhotoColumnToUsers < ActiveRecord::Migration
  def up
    remove_column :users, :photo
    add_column :users, :photot, :binary
  end
  
  def down
    remove_column :users, :photo
    add_column :users, :photot, :hstore
  end
end

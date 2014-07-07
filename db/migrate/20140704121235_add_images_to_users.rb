class AddImagesToUsers < ActiveRecord::Migration
  def up
    remove_column :users, :photot
    add_column :users, :menu_image, :binary
    add_column :users, :page_image, :binary
  end
  
  def down
    add_column :users, :photot, :binary
    remove_column :users, :menu_image
    remove_column :users, :page_image
  end
end

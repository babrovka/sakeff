class AddPhotoToUsers < ActiveRecord::Migration
  def change
     add_column :users, :photo, :hstore  
  end
end

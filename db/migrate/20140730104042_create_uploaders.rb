class CreateUploaders < ActiveRecord::Migration
  def change
    create_table :uploaders do |t|
      t.attachment :file
      t.timestamps
    end
  end
end

class CreateUserTmpImages < ActiveRecord::Migration
  def change
    create_table :user_tmp_images do |t|
      t.attachment :image
      t.timestamps
    end
  end
end

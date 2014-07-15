class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.uuid :user_id
      t.uuid :role_id
      t.timestamps
    end
  end
end

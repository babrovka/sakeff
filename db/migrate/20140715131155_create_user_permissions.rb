class CreateUserPermissions < ActiveRecord::Migration
  def change
    create_table :user_permissions do |t|
      t.uuid :user_id
      t.uuid :permission_id
      t.integer :result, null: false, default: 0
      t.timestamps
    end
  end
end

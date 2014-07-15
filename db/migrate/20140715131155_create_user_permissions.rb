class CreateUserPermissions < ActiveRecord::Migration
  def change
    create_table :user_permissions do |t|
      t.uuid :user_id
      t.uuid :permission_id
      t.string :result, null: false, default: 'default'
      t.timestamps
    end
  end
end

class CreateRolePermissions < ActiveRecord::Migration
  def change
    create_table :role_permissions do |t|
      t.uuid :role_id
      t.uuid :permission_id
      t.integer :result, null: false, default: 0
      t.timestamps
    end
  end
end

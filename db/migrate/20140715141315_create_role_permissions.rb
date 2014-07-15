class CreateRolePermissions < ActiveRecord::Migration
  def change
    create_table :role_permissions do |t|
      t.uuid :role_id
      t.uuid :permission_id
      t.string :result, null: false, default: 'default'
      t.timestamps
    end
  end
end

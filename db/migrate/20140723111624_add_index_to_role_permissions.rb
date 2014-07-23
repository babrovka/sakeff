class AddIndexToRolePermissions < ActiveRecord::Migration
  def change
    add_index :role_permissions, [:role_id, :permission_id], :unique => true
  end
end

class AddUniqueIndexToUserPermissions < ActiveRecord::Migration
  def change
    UserPermission.destroy_all
    add_index :user_permissions, [ :user_id, :permission_id ], :unique => true, :name => 'by_user_and_permission'
  end
end

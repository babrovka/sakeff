require 'webdack/uuid_migration/helpers'

class ChangeOrganizationIdTypeToUsers < ActiveRecord::Migration
  def up
    columns_to_uuid :users, :organization_id
  end
  
  def down
    remove_column :users, :organization_id
    add_column :users, :organization_id, :integer
  end
end

require 'webdack/uuid_migration/helpers'

class ChangeUserTable < ActiveRecord::Migration
  def up
    primary_key_to_uuid :users
    change_column :users, :username, :string, limit: 32, null: false
    add_column :users, :email, :string, limit: 32
    change_column :users, :first_name, :string, limit: 32
    change_column :users, :last_name, :string, limit: 32
    change_column :users, :middle_name, :string, limit: 32
    change_column :users, :title, :string, limit: 64
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end

end

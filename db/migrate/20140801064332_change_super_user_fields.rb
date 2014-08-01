class ChangeSuperUserFields < ActiveRecord::Migration
  def change
    change_column :super_users, :label, :string, limit: 32
    change_column :super_users, :email, :string, limit: 32
  end
end

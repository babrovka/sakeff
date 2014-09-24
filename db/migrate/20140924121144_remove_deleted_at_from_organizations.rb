class RemoveDeletedAtFromOrganizations < ActiveRecord::Migration
  def up
    remove_column :organizations, :deleted_at
  end

  def down
    add_column :organizations, :deleted_at, :datetime
  end
end

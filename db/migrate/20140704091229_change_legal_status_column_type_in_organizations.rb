class ChangeLegalStatusColumnTypeInOrganizations < ActiveRecord::Migration
  def change
    remove_column :organizations, :legal_status
    add_column :organizations, :legal_status, :integer
  end
end

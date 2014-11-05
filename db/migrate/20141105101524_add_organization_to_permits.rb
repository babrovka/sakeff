class AddOrganizationToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :organization, :string
  end
end

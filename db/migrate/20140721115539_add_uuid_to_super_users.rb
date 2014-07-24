class AddUuidToSuperUsers < ActiveRecord::Migration
  def change
    add_column :super_users, :uuid, :uuid, default: "uuid_generate_v4()"
  end
end

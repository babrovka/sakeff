class RecreateOrganizationsTable < ActiveRecord::Migration
  def up
    drop_table :organizations
    create_table :organizations, id: :uuid  do |t|
      t.integer  :legal_status
      t.string   :short_title, :limit => 32
      t.string   :full_title, :limit => 128
      t.string   :inn, :limit => 10
      t.timestamps
    end
  end
end

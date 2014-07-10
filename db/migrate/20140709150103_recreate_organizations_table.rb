class RecreateOrganizationsTable < ActiveRecord::Migration
  def up
    drop_table :organizations
    create_table :organizations, id: :uuid  do |t|
      t.integer  :legal_status, :null => false
      t.string   :short_title, :limit => 32, :null => false
      t.string   :full_title, :limit => 128, :null => false
      t.string   :inn, :limit => 10, :null => false
      t.timestamps
    end
  end
end

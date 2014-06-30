class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string   :legal_status
      t.string   :short_title
      t.string   :full_title
      t.string   :inn
      t.timestamps
    end
  end
end

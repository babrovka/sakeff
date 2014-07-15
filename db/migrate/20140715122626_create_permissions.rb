class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions, id: :uuid  do |t|
      t.string :title, limit: 32, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end

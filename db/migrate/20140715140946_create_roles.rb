class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles, id: :uuid  do |t|
      t.string :title, limit: 32, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end

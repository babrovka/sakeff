class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units, id: :uuid  do |t|
      t.string :label, null: false
      t.uuid :parent_id
      t.integer :has_children, default: 0

      t.timestamps
    end
  end
end

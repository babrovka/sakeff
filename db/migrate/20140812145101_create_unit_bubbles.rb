class CreateUnitBubbles < ActiveRecord::Migration
  def change
    create_table :unit_bubbles, id: :uuid do |t|
      t.integer :bubble_type, null: false
      t.text :comment
      t.integer :unit_id, null: false

      t.timestamps
    end
  end
end

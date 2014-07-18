class CreateControlEvents < ActiveRecord::Migration
  def change
    create_table :control_events do |t|
      t.integer :from_state_id
      t.integer :to_state_id
      t.string :name
      t.string :system_name

      t.timestamps
    end
  end
end

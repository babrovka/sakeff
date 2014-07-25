class CreateControlStates < ActiveRecord::Migration
  def change
    create_table :control_states do |t|
      t.string :name
      t.string :system_name
      t.integer :regulation_id

      t.timestamps
    end
  end
end

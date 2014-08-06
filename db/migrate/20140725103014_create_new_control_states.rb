class CreateNewControlStates < ActiveRecord::Migration
  def change
    create_table :control_states, id: :uuid do |t|
      t.string :name
      t.string :system_name
    end
  end
end

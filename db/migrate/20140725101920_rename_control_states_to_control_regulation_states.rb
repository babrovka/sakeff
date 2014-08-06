class RenameControlStatesToControlRegulationStates < ActiveRecord::Migration
  def change
    rename_table :control_states, :control_regulation_states
  end
end

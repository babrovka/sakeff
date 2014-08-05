class AddIsNormalToControlStates < ActiveRecord::Migration
  def change
    add_column :control_states, :is_normal, :boolean
  end
end

class ChangeTransitionsLinksToUuids < ActiveRecord::Migration
  def up
    rename_table :control_events, :control_regulation_state_events

    remove_column :control_regulation_state_events, :from_state_id
    remove_column :control_regulation_state_events, :to_state_id


    add_column :control_regulation_state_events, :from_regulation_state_id, :uuid
    add_column :control_regulation_state_events, :to_regulation_state_id, :uuid
  end

  def down
    add_column :control_regulation_state_events, :from_state_id, :integer
    add_column :control_regulation_state_events, :to_state_id, :integer

    remove_column :control_regulation_state_events, :from_regulation_state_id
    remove_column :control_regulation_state_events, :to_regulation_state_id

    rename_table :control_regulation_state_events, :control_events
  end
end

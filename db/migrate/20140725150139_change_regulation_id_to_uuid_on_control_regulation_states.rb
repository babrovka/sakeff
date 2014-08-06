require 'webdack/uuid_migration/helpers'

class ChangeRegulationIdToUuidOnControlRegulationStates < ActiveRecord::Migration
  def up
    columns_to_uuid :control_regulation_states, :regulation_id
  end
  
  def down
    remove_column :control_regulation_states, :regulation_id
    add_column :control_regulation_states, :regulation_id, :integer
  end
end

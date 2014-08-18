class ChangeUnitIdToUuid < ActiveRecord::Migration
  def change
    remove_column :unit_bubbles, :unit_id
    add_column :unit_bubbles, :unit_id, :uuid
  end
end

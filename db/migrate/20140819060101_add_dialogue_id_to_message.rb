class AddDialogueIdToMessage < ActiveRecord::Migration
  def change
    add_column :im_messages, :dialogue_id, :uuid
  end
end

class RemoveOldMessageFuntionality < ActiveRecord::Migration
  def up
    drop_table :message_recipients
    drop_table :user_dialogues
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

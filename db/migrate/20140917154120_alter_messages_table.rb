class AlterMessagesTable < ActiveRecord::Migration
  def up
    change_table :im_messages do |t|
      t.remove :dialogue_id
      t.rename :message_type, :reach
      t.uuid :receiver_id  
      t.rename :sender_id, :sender_user_id
      t.uuid :sender_id
    end
  end

  def down
    change_table :im_messages do |t|
      t.uuid :dialogue_id
      t.rename :reach, :message_type
      t.remove :receiver_id
      t.remove :sender_id
      t.rename :sender_user_id, :sender_id
    end
  end
end

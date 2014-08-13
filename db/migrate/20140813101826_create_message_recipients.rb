class CreateMessageRecipients < ActiveRecord::Migration
  def change
    create_table :message_recipients, :id => false do |t|
      t.uuid :message_id
      t.uuid :user_id
      t.timestamps
    end
  end
end

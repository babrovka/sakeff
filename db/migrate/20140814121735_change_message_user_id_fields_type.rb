class ChangeMessageUserIdFieldsType < ActiveRecord::Migration
  def change
    remove_column :im_messages, :sender_id
    add_column :im_messages, :sender_id, :uuid
  end
end

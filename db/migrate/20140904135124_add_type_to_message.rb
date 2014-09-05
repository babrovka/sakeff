class AddTypeToMessage < ActiveRecord::Migration
  def change
    add_column :im_messages, :message_type, :integer, default: 0
  end
end

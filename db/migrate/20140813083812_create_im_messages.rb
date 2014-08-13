class CreateImMessages < ActiveRecord::Migration
  def change
    create_table :im_messages do |t|
      t.text :text
      t.integer :sender_id
      t.integer :recipient_id
      t.boolean :opened
      t.boolean :private
      t.datetime :sent_at

      t.timestamps
    end
  end
end

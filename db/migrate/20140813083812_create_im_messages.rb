class CreateImMessages < ActiveRecord::Migration
  def change
    create_table :im_messages, id: :uuid do |t|
      t.text :text
      t.integer :sender_id

      t.timestamps
    end
  end
end

class CreateRingbellNotifications < ActiveRecord::Migration
  def change
    create_table :ringbell_notifications do |t|
      t.integer :notifiable_id, null: false
      t.string :notifiable_type
      t.uuid :user_id, null: false
      t.string :message
    end

    add_index :ringbell_notifications, [:notifiable_id, :notifiable_type, :user_id], unique: true, name: 'notification_uniqueness'
  end
end

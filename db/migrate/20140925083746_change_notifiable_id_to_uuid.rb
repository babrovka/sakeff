class ChangeNotifiableIdToUuid < ActiveRecord::Migration
  def up
    change_table :ringbell_notifications do |t|
      t.remove :notifiable_id
      t.uuid :notifiable_id
    end

    Ringbell::Notification.destroy_all
  end
  
  def down
    change_table :ringbell_notifications do |t|
      t.remove :notifiable_id
      t.integer :notifiable_id
    end

    Ringbell::Notification.destroy_all
  end
end

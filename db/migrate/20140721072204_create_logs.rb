class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :scope, limit: 32, null: false
      t.uuid :user_id, null: false
      t.uuid :object_id
      t.string :event_type, limit: 64, null: false
      t.string :result, limit: 32, null: false
      t.string :comment, limit: 1024
      t.timestamps
    end
  end
end

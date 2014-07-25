class RecreateControlRegulations < ActiveRecord::Migration
  def up
    drop_table :control_regulations
    create_table :control_regulations, id: :uuid do |t|
      t.string :name
      t.uuid :state_id
      t.uuid :role_id

      t.timestamps
    end
  end
  
  def down
    drop_table :control_regulations
    create_table :control_regulations do |t|
      t.string :name
      t.datetime :activated_at

      t.timestamps
    end
  end
end

  
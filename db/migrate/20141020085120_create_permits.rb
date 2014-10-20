class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.integer :doc_type
      t.string :doc_number
      t.integer :vehicle_type
      t.string :car_brand
      t.string :car_number
      t.string :region
      t.boolean :drive_list
      t.string :person
      t.string :location
      t.datetime :starts_at
      t.datetime :expires_at
      

      t.timestamps
    end
  end
end

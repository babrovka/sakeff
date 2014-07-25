class CreateControlRegulations < ActiveRecord::Migration
  def change
    create_table :control_regulations do |t|
      t.string :name

      t.timestamps
    end
  end
end

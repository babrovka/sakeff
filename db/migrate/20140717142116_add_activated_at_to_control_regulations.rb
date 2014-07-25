class AddActivatedAtToControlRegulations < ActiveRecord::Migration
  def change
    add_column :control_regulations, :activated_at, :datetime
  end
end

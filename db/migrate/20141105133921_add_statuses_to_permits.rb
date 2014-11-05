class AddStatusesToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :status, :integer, default: 0
  end
end

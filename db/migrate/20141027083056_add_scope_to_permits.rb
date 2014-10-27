class AddScopeToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :once, :boolean, default: false
    add_column :permits, :car, :boolean, default: false
    add_column :permits, :human, :boolean, default: false
  end
end

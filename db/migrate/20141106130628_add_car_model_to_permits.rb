class AddCarModelToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :car_model, :string
  end
end

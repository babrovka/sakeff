class AddCellPhoneNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cell_phone_number, :string, limit: 32
  end
end

class ChangeSerialNumberForDocuments < ActiveRecord::Migration
  def change
    change_column :documents, :serial_number, 'integer USING CAST(serial_number AS integer)'
    
    execute "CREATE SEQUENCE documents_serial_number_seq START 1"
  end
end

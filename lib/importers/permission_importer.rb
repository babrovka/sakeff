class Importers::PermissionImporter < Importers::Importer
  class << self

    private
    
    def before_import
      Permission.destroy_all
      puts 'permissions destroyed' unless Rails.env.test?
    end

    def save_data(row, index)
      unless index == 0 || Permission.exists?(:title => row[1]) || row[0] == nil
        Permission.create!({
                              id: row[0],
                              title: row[1],
                              description: row[2]
                          })
      end
    end

    def default_file_path
      'db/excel/Permissions.xls'
    end

    def default_sheet_name
      'Permissions'
    end

  end
end
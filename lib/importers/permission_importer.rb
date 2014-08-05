class Importers::PermissionImporter < Importers::Importer
  class << self

    private

    def save_data(row, index)
      unless index == 0 || Permission.exists?(:title => row[0])
        Permission.create({
                              title: row[0],
                              description: row[1]
                          })
      end
    end

    def default_file_path
      'db/excel/roles_and_permissions.xls'
    end

    def default_sheet_name
      'permissions'
    end

  end
end
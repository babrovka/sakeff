class Importers::RoleImporter < Importers::Importer
  class << self

    private

    def save_data(row, index)
      unless index == 0 || Role.exists?(:title => row[0])
        Role.create({
                        title: row[0],
                        description: row[1]
                    })
      end
    end

    def default_file_path
      'db/excel/roles_and_permissions.xls'
    end

    def default_sheet_name
      'roles'
    end

  end
end
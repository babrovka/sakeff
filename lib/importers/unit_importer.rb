class Importers::UnitImporter < Importers::Importer
  class << self

    private

    def save_data(row, index)
      unless index == 0 || Unit.exists?(:label => row[0])
        Unit.create({
                        label: row[0],
                        id: row[1],
                        parent_id: row[2]
                    })
      end
    end

    def default_file_path
      'db/excel/units.xls'
    end

    def default_sheet_name
      'units'
    end

  end
end
class Importers::UnitImporter < Importers::Importer
  class << self

    private

    def save_data(row, index)
      unless index == 0 || Unit.exists?(:id => row[1])
        Unit.create({
                        label: row[0],
                        id: row[1],
                        parent_id: row[2]
                    })
      end
    end

    def after_import
      Unit.all.each do |unit|
        unit.has_children = unit.children.count
        unit.save!
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
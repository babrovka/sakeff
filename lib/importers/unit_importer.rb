class Importers::UnitImporter < Importers::Importer
  class << self

    private
    
    def before_import
      Unit.delete_all
      puts 'units destroyed'
    end

    def save_data(row, index)
      return if index == 0
      return if !row[0].present?
      return if !row[1].present?
      puts "'#{index}' '#{row[0]}' '#{row[1]}' '#{!row[0].present?}'"
      if row[2] == 0
        row[2] = nil
      end
      unit = Unit.create({
                      label: row[0],
                      id: row[1],
                      parent_id: row[2], 
                      model_filename: row[3]
                  })
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
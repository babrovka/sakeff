class Importers::UnitImporter < Importers::Importer
  class << self

    private
    
    def before_import
      Unit.destroy_all
      puts 'units destroyed'
    end

    def save_data(row, index)
      unless index == 0 || Unit.exists?(:id => row[1]) || row[0] == nil
        if row[2] == 0
          row[2] = nil
        end
        unit = Unit.create({
                        label: row[0],
                        id: row[1],
                        parent_id: row[2], 
                        model_filename: row[3]
                    })
                    
        puts "#{unit.id} | #{unit.parent_id}"
        # puts "\"#{row[0]}\""
        # puts "\"#{row[1]}\""
        # puts "\"#{row[2]}\""
        # puts "\"#{row[3]}\""
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
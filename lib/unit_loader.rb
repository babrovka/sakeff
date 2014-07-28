# xls файл должен содержать столбцы:
# label в первом столбце
# id (uuid) во втором столбце
# parent_id (uuid) в третьем столбце

require 'spreadsheet'
require 'fileutils'

# @example
#   UnitLoader.new("db/excel/units.xls").load_units
class UnitLoader

  def initialize(file_path, sheet_name='units')
    # Файл не существует?
    raise "Can't find #{file_path}" unless File.exists? file_path

    book = Spreadsheet.open file_path
    @sheet = book.worksheet sheet_name

    # Лист не существует?
    raise "Sheet #{sheet_name} doesn't exists" unless @sheet
  end

  def load_units
    @sheet.each_with_index do |row, index|
      next if index == 0
      Unit.create({
        label: row[0],
        id: row[1],
        parent_id: row[2]
      })
    end
    Unit.all.each do |unit|
      unit.has_children = unit.children.count
      unit.save!
    end
    puts 'Units imported'
  end
  handle_asynchronously :load_units


end

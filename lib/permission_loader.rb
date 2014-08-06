# xls файл должен содержать столбцы:

require 'spreadsheet'
require 'fileutils'

class PermissionLoader


  def self.import()

    # Получаем данные
    file_path = 'db/excel/roles_and_permissions.xls'

    # Файл не существует?
    raise "Can't find #{file_path}" unless File.exists? file_path

    book = Spreadsheet.open file_path
    @sheet = book.worksheet 'permissions'

    # Лист не существует?
    raise "Sheet #{sheet_name} doesn't exists" unless @sheet
    @sheet.each_with_index do |row, index|
      next if index == 0 || Permission.exists?(:title => row[0])
      Permission.create({
                            title: row[0],
                            description: row[1]
                        })
    end

    puts 'Permission imported'
  end


end

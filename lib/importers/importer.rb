require 'spreadsheet'
require 'fileutils'

class Importers::Importer

  class << self

    def import()
      file_sheet.each_with_index do |row, index|
        save_data(row, index)
      end

      after_import()

      puts "Import finish"
    end


    private

    def save_data(row, index)
    end


    def after_import()
    end

    def file_sheet
      # Файл не существует?
      raise "Can't find #{file_path}" unless File.exists? file_path

      book = Spreadsheet.open file_path
      sheet = book.worksheet sheet_name

      # Лист не существует?
      raise "Sheet #{sheet_name} doesn't exists" unless sheet

      sheet
    end
  end


end
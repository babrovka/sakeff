# coding: utf-8

require 'csv'
require 'faker'
require 'populator'
require 'spreadsheet'
require "readline"

# Получает данные листа xls-файла
# Возвращает объект Spreadsheet::Worksheet
def get_xls_spreadsheet file_path, sheet_name
  # Файл не существует?
  raise "Can't find #{file_path}" unless File.exists? file_path

  book = Spreadsheet.open file_path
  sheet = book.worksheet sheet_name

  # Лист не существует?
  raise "Sheet #{sheet} doesn't exists" unless sheet

  return sheet
end

namespace :excel do
  desc "Import permissions"
  task permissions: :environment do
    # Получаем данные
    org_sheet = get_xls_spreadsheet 'db/excel/roles_and_permissions.xls', 'permissions'

    # Создаем объекты
    org_sheet.each_with_index do |row, index|
      next if index == 0 || Permission.exists?(:title => row[0])

      
      Permission.create({
        title: row[0],
        description: row[1]
      })
    end
    puts 'Permissions imported'
  end
end

namespace :excel do
  desc "Import roles"
  task roles: :environment do
    # Получаем данные
    org_sheet = get_xls_spreadsheet 'db/excel/roles_and_permissions.xls', 'roles'

    # Создаем объекты
    org_sheet.each_with_index do |row, index|
      next if index == 0 || Role.exists?(:title => row[0])
      
      Role.create({
        title: row[0],
        description: row[1]
      })
    end
    puts 'Roles imported'
  end
end


# SuperUser
namespace :super_user do
  
  task :create => :environment do
    u = SuperUser.new
    puts 'enter email'
    email = Readline.readline("> ", true)
    puts 'enter password (should be at least 8 symbols)'
    system "stty -echo"
    password = Readline.readline("> ", true)  
    puts 'enter password confirmation'
    password_confirmation = Readline.readline("> ", true)
    system "stty echo"
    puts 'enter label'
    label = Readline.readline("> ", true)    
    u.label = label
    u.email = email
    u.password = password
    u.password_confirmation = password_confirmation
    if u.save
      puts 'SuperUser created'
    else
      puts u.errors.full_messages
    end  
  end
  
  task :list => :environment do
    SuperUser.all.each do |u|
      puts "#{u.label}(#{u.email})"
    end
  end
  
  task :delete => :environment do
    puts 'enter email'
    email = Readline.readline("> ", true)
    SuperUser.where(email: email).first.destroy
    puts 'Super User destroyed'
  end
  
  task :edit => :environment do
    puts 'enter email'
    email = Readline.readline("> ", true)
    u = SuperUser.where(email: email).first
    puts "press enter to leave current email [#{u.email}]"
    new_email = Readline.readline("> ", true)
    u.email = new_email unless new_email.empty?
    puts "press enter to leave current label [#{u.label}]"
    new_label = Readline.readline("> ", true)
    u.label = new_label unless new_label.empty?
    puts "press enter to leave current password (new password should be at least 8 symbols)"
    system "stty -echo"
    new_password = Readline.readline("> ", true)
    unless new_password.empty?
      puts "enter new password again"
      password_confirmation = Readline.readline("> ", true)
      if new_password == password_confirmation
        u.password = new_password 
        u.password_confirmation = new_password
      else
        puts "password confirmation is invalid"
      end
    end
    system "stty echo"
    if u.save
      puts 'SuperUser updated'
    else
      puts u.errors.full_messages
    end
  end
  
end
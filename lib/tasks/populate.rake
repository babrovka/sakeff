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
    Importers::PermissionImporter.import
  end
end

namespace :excel do
  desc "Import roles"
  task roles: :environment do
    Importers::RoleImporter.import
  end
end

namespace :excel do
  desc "Import units"
  task units: :environment do  
    Importers::UnitImporter.import
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


# for Dev
namespace :dev do
  
  task :org_and_user => :environment do
    org = Organization.create!(legal_status: "ooo", short_title: "Циклон", full_title: "Циклон", inn: 1234567899)
    User.create!(username: 'babrovka', password: 'password', password_confirmation: 'password', organization_id: org.id)
  end
end


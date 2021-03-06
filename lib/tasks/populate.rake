# coding: utf-8

require 'csv'
require 'faker'
require 'populator'
require 'spreadsheet'
require 'readline'


# Importing from excel file.
namespace :excel do
  desc "Import permissions"
  task permissions: :environment do
    Importers::PermissionImporter.import
  end

  desc "Import roles"
  task roles: :environment do
    Importers::RoleImporter.import
  end

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

  task bubbles_for_units: :environment do
    Unit.all.each do |unit|
      4.times do 
        UnitBubble.create!(bubble_type: rand(0..3), unit_id: unit.id)
        puts 'bubble created!'
      end
    end
  end
  
  task org_and_user: :environment do
    SuperUser.create!(email: 'babrovka@gmail.com', password: 'password', password_confirmation: 'password', label: 'babrovka')
    org = Organization.create!(legal_status: "ooo", short_title: "Циклон", full_title: "Циклон", inn: 8765456787)
    User.create!(username: 'babrovka', password: 'password', password_confirmation: 'password', organization_id: org.id, first_name: 'babrovka', last_name: 'babrovka', middle_name: 'Андреевич', title: 'Инженер')
  end

  task destroy_states: :environment do
    Control::State.destroy_all
  end


  task dispatcher: :environment do
    u = User.where(username: 'kirillica').first
    p = Permission.where(title: 'dispatcher').first
    u.permissions << p
    UserPermission.where(user: u, permission: p).first.update(result: 1)


    puts 'Dispatcher created'
  end


  desc 'Messages without Dialogue move to Dialogue for all users'
  task move_messages_to_dialogues: :environment do
    dialogues_message_ids = Im::Dialogue.all.map { |d| d.messages.pluck(:id) }.flatten
    all_message_ids = Im::Message.pluck(:id)

    diff_messages_ids = all_message_ids - dialogues_message_ids

    messages_to_move = Im::Message.where(id: diff_messages_ids)
    users = User.all

    if users.count && messages_to_move.count
      dialogue = Im::Dialogue.create!(users: users, messages: messages_to_move)
      puts "Moved #{diff_messages_ids.count} messages to Dialogue with id=#{dialogue.id}"
    else
      puts 'Nothing to move'
    end

  end
end

namespace :templates do
  desc 'Create template states or update existing by <system_name>'
  task states: :environment do
    [
        { name: 'Нормальная эксплуатация', system_name: 'normal_operation', is_normal: true },
        { name: 'Угроза наводнения', system_name: 'floods_threat', is_normal: false },
        { name: 'Наводненческая ситуация', system_name: 'flood', is_normal: false },
        { name: 'Чрезвычайная или аварийная ситуации', system_name: 'emergency', is_normal: false }
    ].each do |state_attrs|
      state = Control::State.where(system_name: state_attrs[:system_name]).first
      unless state.blank?
        state.update_attributes(state_attrs)
      else
        Control::State.create!(state_attrs)
      end
    end

    puts 'Template states added/updated.'
  end
end


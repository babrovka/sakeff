# coding: utf-8

require 'csv'
require 'faker'
require 'populator'
require 'spreadsheet'
require "readline"

namespace :super_user do
  
  task :create => :environment do
    u = SuperUser.new
    puts 'enter email'
    email = Readline.readline("> ", true)
    puts 'enter password (should be at least 8 symbols)'
    password = Readline.readline("> ", true)
    puts 'enter password confirmation'
    password_confirmation = Readline.readline("> ", true)
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
      puts u.email
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
    if u.save
      puts 'SuperUser updated'
    else
      puts u.errors.full_messages
    end

    
  end
  


end



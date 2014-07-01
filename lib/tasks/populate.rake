# coding: utf-8

require 'csv'
require 'faker'
require 'populator'
require 'spreadsheet'

namespace :db do
  
  task :create_superusers => :environment do
    SuperUser.destroy_all
    SuperUser.create!(:label => 'superadmin', :email => 'supeadmin@cyclonelabs.com', :password => 'password', :password_confirmation => 'password')
    puts 'Super Admin created'
  end
  
  task :create_superuser, [:label, :email, :password, :password_confirmation ] => :environment do |t, args|
    u = SuperUser.new
    u.label = args.label
    u.email = args.email
    u.password = args.password
    u.password_confirmation = args.password_confirmation
    if u.save
      puts 'SuperUser created'
    else
      puts u.errors.full_messages
    end
  end
  


end



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
  


end



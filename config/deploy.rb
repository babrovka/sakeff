require 'bundler/capistrano'
load 'deploy/assets'
require 'hipchat/capistrano'
require "delayed/recipes" 
set :delayed_job_command, "bin/delayed_job"
load 'config/recipes/dev'
load 'config/recipes/demo'
load 'config/recipes/production'
require 'bundler/capistrano'
load 'deploy/assets'
require 'hipchat/capistrano'
require "delayed/recipes" 
set :delayed_job_command, "bin/delayed_job"

module UseScpForDeployment
  def self.included(base)
    base.send(:alias_method, :old_upload, :upload)
    base.send(:alias_method, :upload,     :new_upload)
  end

  def new_upload(from, to, options = {}, &block)
  old_upload(from, to, options.merge(:via => :scp), &block)
  end
end

task :copy_database_config do
   db_config = "#{shared_path}/database.yml"
   run "cp #{db_config} #{latest_release}/config/database.yml"
end

task :copy_secret_config do
   db_config = "#{shared_path}/secrets.yml"
   run "cp #{db_config} #{latest_release}/config/secrets.yml"
end

task :import_permissions do
   run %Q{cd #{latest_release} && RAILS_ENV=dev bundle exec rake excel:permissions}
end

task :maps_and_tree do
   run %Q{cd #{latest_release} && scripts/sort.sh && RAILS_ENV=dev bundle exec rake excel:units}
end

Capistrano::Configuration.send(:include, UseScpForDeployment)

server "mercury.cyclonelabs.com", :web, :app, :db, primary: true

ssh_options[:port] = 23813

set :user, "babrovka"
set :application, "kzs"
set :deploy_to, "/srv/webdata/sakedev.cyclonelabs.com"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:babrovka/sakeff.git"
set :branch, "dev"
set :rails_env, "dev"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :hipchat_token, "9ccb22cbbd830fcd68cf2289a4f34b"
set :hipchat_room_name, "430075"
set :hipchat_announce, true


# закомментировать перед первым или чистым деплоем
# иначе ошибочки будут
namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile --trace}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end


namespace(:thin) do
  task :stop do
    run %Q{cd #{latest_release} && RAILS_ENV=dev bundle exec thin stop -C #{shared_path}/sakedev.yml}
   end

  task :start do
    run %Q{cd #{latest_release} && RAILS_ENV=dev bundle exec thin start -C #{shared_path}/sakedev.yml}
  end

  task :restart do
    stop
    start
  end
end


namespace :private_pub do
  desc "Start private_pub server"
  task :start do
    # old command
    run %Q{cd #{latest_release} && RAILS_ENV=dev bundle exec thin start -C #{shared_path}/private_pub.yml }
    # run %Q{cd #{latest_release} && RAILS_ENV=dev bundle exec thin -C #{shared_path}/private_pub.yml start }

  end

  # recipes from github
  desc "Stop private_pub server"
  task :stop do
    # old command
    # run "cd #{current_path};if [ -f tmp/pids/private_pub.pid ] && [ -e /proc/$(cat tmp/pids/private_pub.pid) ]; then kill -9 `cat tmp/pids/private_pub.pid`; fi"
    run %Q{cd #{latest_release} && RAILS_ENV=dev bundle exec thin -C #{shared_path}/private_pub.yml stop}
  end

  desc "Restart private_pub server"
  task :restart do
    stop
    start
  end
end

namespace(:populate) do
  task :data do
    run %Q{cd #{latest_release} && bundle exec rake db:seed RAILS_ENV=dev}
  end
end

namespace(:log) do
  task :rails do
    run %Q{cd #{shared_path} && tailf -n 50 log/dev.log }
  end
  
  task :thin do
    run %Q{cd #{shared_path} && tailf -n 50 log/thin.log }
  end
end


before "deploy:assets:precompile", "copy_database_config"
after "copy_database_config", "copy_secret_config"
after "copy_secret_config", "import_permissions"
after "import_permissions", "maps_and_tree"

after "thin:stop",    "delayed_job:stop"
after "thin:start",   "delayed_job:start"
after "thin:restart", "delayed_job:restart"
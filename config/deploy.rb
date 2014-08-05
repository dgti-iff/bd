require "bundler/capistrano"

set :bundle_flags, "--deployment"
server "10.0.1.79", :web, :app, :db, primary: true

set :application, "bd"
set :user, "deploy"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "https://github.com/dgti-iff/bd.git"
set :branch, "master"

set :shared_children, shared_children + %w{public/uploads}

before "deploy:cold", "deploy:install_bundler"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true


after "deploy", "deploy:cleanup", "deploy:precompile_assets" # keep only the last 5 releases
#after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  desc "Override deploy:cold to NOT run migrations - there's no database"
  task :cold do
    update
    start
  end
  
  task :precompile_assets do
    run "cd #{latest_release}; bundle exec rake assets:precompile"
    run "cd #{latest_release}; cp app/assets/images/* public/assets/; cp app/assets/files/* public/assets/"
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end

  task :install_bundler, :roles => :app do
    run "type -P bundle &>/dev/null || { gem install bundler --no-rdoc --no-ri; }"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    put File.read("config/elasticsearch.yml.example"), "#{shared_path}/config/elasticsearch.yml"
    put File.read("config/mail.yml.example"), "#{shared_path}/config/mail.yml"
    put File.read("config/sam.yml.example"), "#{shared_path}/config/sam.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/elasticsearch.yml #{release_path}/config/elasticsearch.yml"
    run "ln -nfs #{shared_path}/config/mail.yml #{release_path}/config/mail.yml"
    run "ln -nfs #{shared_path}/config/sam.yml #{release_path}/config/sam.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
  
  task :symlink_uploads, roles: :app do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "deploy:symlink_uploads"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

# frozen_string_literal: true
lock '~> 3.11.0'

set :application, 'task_manage'
set :repo_url, 'git@github.com:seinomasaki/task_manage.git'
set :deploy_to, '/var/www/rails/task_manage'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :rbenv_ruby, '2.5.1'
set :rbenv_custom_path, '/home/masaki/.rbenv/'
set :format, :pretty
set :log_level, :debug
set :linked_files, %w{config/master.key}

namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :confirm do
    on roles(:app) do
      puts "This stage is '#{fetch(:stage)}'. Deploying branch is '#{fetch(:branch)}'."
      puts 'Are you sure? [y/n]'
      ask :answer, 'n'
      if fetch(:answer) != 'y'
        puts 'deploy stopped'
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart Application'
  task :initial do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting, :confirm
end
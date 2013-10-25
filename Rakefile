require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :db)

namespace :db do
  desc "Create the database, replacing any existing tables that may exist. Use with caution"
  task :create do 
    DataMapper::Logger.new($stdout, :debug)
    require './conf/database'
    puts "Checking the database for errors…"
    DataMapper.finalize
    puts "Dropping any existing tables and creating new ones…"
    DataMapper.auto_migrate!
    puts "Done!"
  end

  desc "Non-destructively migrates the database"
  task :migrate do
    DataMapper::Logger.new($stdout, :debug)
    require './conf/database'
    puts "Checking the database for errors…"
    DataMapper.finalize
    puts "Migrating the database"
    DataMapper.auto_update!    
  end
end

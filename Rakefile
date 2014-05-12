require 'rspec/core/rake_task'
require 'sqlite3'

$LOAD_PATH << "lib"
require 'database'

RSpec::Core::RakeTask.new(:spec)

task :default => [:prepare_database, :test_prepare, :spec]

desc 'create the production database setup'
task :prepare_database do
  production_db = 'db/budget_production.sqlite3'
  Database.environment = 'production'
  unless File.exist?(production_db)
    Database.connection.create_tables
  end
end

desc 'prepare the test database'
task :test_prepare do
  test_db = 'db/budget_test.sqlite3'
  File.delete(test_db) if File.exist?(test_db)
  Database.environment = 'test'
  Database.connection.create_tables
end


#---Quick Methods to show what's in the databases---#
desc 'print test database to terminal'
task :print_test_db do
  Database.environment = 'test'
  db = Database.new('db/budget_test.sqlite3')

  puts "-------EXPENSES-------"
  expenses = db.execute("SELECT * FROM expenses")
  expenses.each do |expense|
    puts expense
    puts "====================="
  end
end

desc 'print production database to terminal'
task :print_db do
  Database.environment = 'production'
  db = Database.new('db/budget_production.sqlite3')

  puts "-------EXPENSES-------"
  expenses = db.execute("SELECT * FROM expenses")
  expenses.each do |expense|
    puts expense
    puts "====================="
  end
end

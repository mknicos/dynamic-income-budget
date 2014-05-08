require 'rspec/core/rake_task'
require 'sqlite3'

$LOAD_PATH << "lib"
require 'database'

RSpec::Core::RakeTask.new(:spec)

task :default => [:prepare_database, :test_prepare, :spec]

desc 'create the production database setup'
task :prepare_database do
  production_db = 'db/budget_production.sqlite3'
  unless File.exist?(production_db)
    Database.environment = 'production'
    db = Database.new(production_db)
    db.execute("CREATE TABLE expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
    db.execute("CREATE TABLE incomes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
  end
end

desc 'prepare the test database'
task :test_prepare do
  test_db = 'db/budget_test.sqlite3'
  File.delete(test_db) if File.exist?(test_db)
  Database.environment = 'test'
  db = Database.new(test_db)
  db.execute("CREATE TABLE expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
  db.execute("CREATE TABLE incomes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
end


#---Quick Methods to show what's in the databases---#
desc 'print test database to terminal'
task :print_test_db do
  db = Database.new('db/budget_test.sqlite3')

  puts "-------EXPENSES-------"
  expenses = db.execute("SELECT * FROM expenses")
  expenses.each do |expense|
    puts expense
    puts "====================="
  end

  puts "-------INCOMES-------"
  incomes = db.execute("SELECT * FROM incomes")
  incomes.each do |income|
    puts income
    puts "====================="
  end
end

desc 'print production database to terminal'
task :print_db do
  db = Database.new('db/budget_production.sqlite3')

  puts "-------EXPENSES-------"
  expenses = db.execute("SELECT * FROM expenses")
  expenses.each do |expense|
    puts expense
    puts "====================="
  end

  puts "-------INCOMES-------"
  incomes = db.execute("SELECT * FROM incomes")
  incomes.each do |income|
    puts income
    puts "====================="
  end
end

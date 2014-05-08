require 'rspec/core/rake_task'
require 'sqlite3'
$LOAD_PATH << "lib"

RSpec::Core::RakeTask.new(:spec)

task :default => [:bootstrap_database, :test_prepare, :spec]

desc 'create the production database setup'
task :bootstrap_database do
  production_db = 'db/budget.sqlite3'
  unless File.exist?(production_db)
    db = SQLite3::Database.new(production_db)
    db.execute("CREATE TABLE expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
    db.execute("CREATE TABLE incomes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
  end
end

desc 'prepare the test database'
task :test_prepare do
  test_db = 'db/budget_test.sqlite3'
  File.delete(test_db) if File.exist?(test_db)
  db = SQLite3::Database.new(test_db)
  db.execute("CREATE TABLE expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
  db.execute("CREATE TABLE incomes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, description TEXT)")
end

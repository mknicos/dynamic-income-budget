require 'rspec/core/rake_task'

$LOAD_PATH << "lib"
require 'database'

RSpec::Core::RakeTask.new(:spec)

task :default => ['db:test:prepare', :spec]

db_namespace = namespace :db do
  desc "Migrate the db"
  task :migrate do
    Database.environment = 'production'
    Database.connect_to_database
    ActiveRecord::Migrator.migrate("db/migrate/")
    db_namespace["schema:dump"].invoke
  end
  namespace :test do
    desc "Prepare the test database"
    task :prepare do
      Database.environment = 'test'
      Database.connect_to_database
      file = ENV['SCHEMA'] || "db/schema.rb"
      if File.exists?(file)
        load(file)
      else
        abort %{#{file} doesn't exist yet. Run `rake db:migrate` to create it.}
      end
    end
  end
  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback do
    Database.environment = 'production'
    Database.connect_to_database
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace["schema:dump"].invoke
  end
  namespace :schema do
    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
    task :dump do
      require 'active_record/schema_dumper'
      Database.environment = 'production'
      Database.connect_to_database
      filename = ENV['SCHEMA'] || "db/schema.rb"
      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end

#---Quick Methods to show what's in the databases---#
desc 'print test database to terminal'
task :print_test_db do
  Database.environment = 'test'
  Database.connect_to_database

  puts "-------EXPENSES-------"
  expenses = Expense.connection.execute("SELECT * FROM expenses")
  expenses.each do |expense|
    puts expense["name"].upcase
    print "$" + expense[:amount].to_s + "\s"
    print expense[:recurrance] + "\n"
    puts expense[:description]
    puts "___________________"
    puts "====================="
    print "\n" 
  end
end

desc 'print production database to terminal'
task :print_db do
  Database.environment = 'production'
  Database.connect_to_database

  puts "-------EXPENSES-------"
  expenses = Expense.connection.execute("SELECT * FROM expenses")
  expenses.each do |expense|
    puts expense
    puts "====================="
  end
end

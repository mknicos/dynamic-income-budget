require 'sqlite3'
require 'logger'

class Database < SQLite3::Database
  def initialize(database)
    super(database)
  end

  def self.environment= environment
    @@environment = environment
  end

  def self.connection
    @connection ||= Database.new("db/budget_#{@@environment}.sqlite3")
  end

  def execute(statement, bind_vars = [])
    Database.logger.info("Executing: #{statement} with: #{bind_vars}")
    super(statement, bind_vars)
  end

  def Database.logger
    @@logger ||= Logger.new("log/#{@@environment}.log")
  end

  def create_tables
    db = Database.connection
    db.execute("CREATE TABLE expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, recurrance TEXT, description TEXT)")
    db.execute("CREATE TABLE incomes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, recurrance TEXT, description TEXT)")
  end
end

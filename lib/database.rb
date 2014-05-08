require 'sqlite3'
require 'logger'

class Database < SQLite3::Database
  @@environment = nil
  def initialize(database)
    super(database)
  end

  def self.environment= environment
    @@environment = environment
  end

  def self.environment
    @@environment
  end

  def execute(statement, bind_vars = [])
    Database.logger.info("Executing: #{statement} with: #{bind_vars}")
    super(statement, bind_vars)
  end

  #currently unused
  def Database.logger
    @@logger ||= Logger.new("log/#{@@environment}.log")
  end
end

require 'database'
class Expense
  attr_reader :name, :amount, :recurrance, :description, :id

  def initialize(name, amount, recurrance, desc)
    @name = name
    @amount = amount.to_i
    @recurrance = recurrance
    @description = desc
  end


  def save
    if self.valid?
      db = Database.connection
      statement = "Insert into expenses (name, amount, recurrance, description) values (?,?,?,?);"
      db.execute(statement, [@name, @amount, @recurrance, @description])
      @id = db.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def self.create(name, amount, recurrance, desc)
    expense = Expense.new(name, amount, recurrance, desc)
    expense.save
    expense
  end

  def valid?
    valid_characters = @name.match /[a-zA-Z]/
    name_already_in_db = Expense.find_by_name(@name)
    if !valid_characters or name_already_in_db
      return false
    else
      return true
    end
  end

  def self.all
    statement = "SELECT * FROM expenses;"
    results = Database.connection.execute(statement)
    results
  end

  def self.count
    statement = "Select count(*) from expenses;"
    result = Database.connection.execute(statement)
    result[0][0]
  end

  def annual_expenses_per_day
    statement = "SELECT SUM(amount) FROM expenses WHERE recurrance = annually;"
    total_annual_expenses = Database.connection.execute(statement)
    days_in_year = 365
    annual_expenses_per_day = total_annual_expenses / days_in_year
    annual_expenses
  end

  def monthly_expenses_per_day

  end

  def self.find_by_name(name)
    statement = "SELECT * FROM expenses WHERE name = ?;"
    result = Database.connection.execute(statement, name)[0]
    return nil if result == nil
    expense = Expense.new(result[1], result[2], result[3], result[4])
    expense.instance_variable_set(:@id, result[0])
    expense
  end

end

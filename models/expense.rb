require 'database'
class Expense
  attr_reader :recurrance, :description, :id, :due_date
  attr_accessor :name, :amount

  def initialize(name, amount, recurrance, desc)
    @name = name
    @amount = amount.to_i
    @recurrance = recurrance
    @description = desc
    @due_date = nil
  end

  def due_date= date
    @due_date = date
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
    statement = "SELECT count(*) FROM expenses;"
    result = Database.connection.execute(statement)
    result[0][0]
  end

  def self.last
    id = Database.connection.execute("SELECT LAST_INSERT_ROWID();")
    statement = "SELECT * FROM expenses WHERE id = ?"
    last_row = Database.connection.execute(statement, id)[0]
    return nil if last_row == nil
    expense = Expense.new(last_row[1],last_row[2],last_row[3],last_row[4])
    expense.instance_variable_set(:@id, last_row[0])
    expense
  end


  def self.annual_expenses_per_day
    statement = "SELECT amount FROM expenses WHERE recurrance = 'annually'"
    annual_expense = Database.connection.execute(statement)

    total_annual_expense = 0
    annual_expense.each do |expense|
      total_annual_expense += expense[0]
    end

    annual_expenses_per_day = (total_annual_expense / 365.00).round(2)
  end

  def self.monthly_expenses_per_day
    statement = "SELECT amount FROM expenses WHERE recurrance = 'monthly'"
    monthly_expense = Database.connection.execute(statement)

    total_monthly_expense = 0
    monthly_expense.each do |expense|
      total_monthly_expense += expense[0]
    end

    monthly_expenses_per_day = (total_monthly_expense * 12 / 365.00).round(2)
  end

  def self.find_by_name(name)
    statement = "SELECT * FROM expenses WHERE name = ?;"
    result = Database.connection.execute(statement, name)[0]
    return nil if result == nil
    expense = Expense.new(result[1], result[2], result[3], result[4])
    expense.instance_variable_set(:@id, result[0])
    expense
  end

  def self.total_expenses_per_day
    monthly_expenses_per_day + annual_expenses_per_day
  end

  def update_name(new_name)
    self.name = new_name
    if self.valid?
      statement = "UPDATE expenses SET name = ? where id = ?;"
      Database.connection.execute(statement,[new_name, self.id])
      true
    else
      false
    end
  end

  def update_amount(new_amount)
    self.amount = new_amount
    if valid_amount?
      statement = "UPDATE expenses SET amount = ? where id = ?;"
      Database.connection.execute(statement,[new_amount, self.id])
      true
    else
      false
    end
  end

  def remove
    statement = "DELETE FROM expenses WHERE name = ?;"
    Database.connection.execute(statement, self.name)
  end

  private

  def valid_amount?
    return false unless self.amount.is_a? Integer
    return false unless self.amount >= 0
    true
  end

=begin
  def self.annual_expenses_per_day
    statement = "SELECT SUM(amount), recurrance FROM expenses GROUP BY recurrance;"
    total_annual_expenses = Database.connection.execute(statement)
    days_in_year = 365
    expenses_per_day = total_annual_expenses / days_in_year
  end
=end
end

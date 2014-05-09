class Expense
  attr_reader :name, :amount, :recurrance, :description, :id

  def initialize(name, amount, recurrance, desc)
    @name = name
    @amount = amount.to_i
    @recurrance = recurrance
    @description = desc
  end


  def save
    statement = "Insert into expenses (name, amount, recurrance, description) values (?,?,?,?);"
    environment = Database.environment
    db = Database.new('db/budget_'+environment+'.sqlite3')
    db.execute(statement, [@name, @amount, @recurrance, @description])
    @id = db.execute("SELECT last_insert_rowid();")
  end

  def valid?
    true
  end

  def self.all
    []
  end

end

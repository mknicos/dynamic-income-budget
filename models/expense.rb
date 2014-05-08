class Expense
  attr_reader :name, :amount, :description

  def initialize(name, amount, desc)
    @name = name
    @amount = amount
    @description = desc
  end

  def valid?

  end

  def save
  end
  

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = database.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      person = Person.new(row["name"])
      person.instance_variable_set(:@id, row["id"])
      results << person
    end
    results
  end

end

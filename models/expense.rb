require 'database'
require 'active_record'

class Expense < ActiveRecord::Base

validates :name, uniqueness: { message: "already exists." }
validates :name, format: { with: /[a-zA-Z]/, message: "is not a valid injury name, as it does not include any letters." }

  def self.annual_expenses_per_day
    statement = "SELECT amount FROM expenses WHERE recurrance = 'annually'"
    annual_expense = Expense.connection.execute(statement)

    total_annual_expense = 0
    annual_expense.each do |expense|
      total_annual_expense += expense[0]
    end

    annual_expenses_per_day = (total_annual_expense / 365.00).round(2)
  end

  def self.monthly_expenses_per_day
    statement = "SELECT amount FROM expenses WHERE recurrance = 'monthly'"
    monthly_expense = Expense.connection.execute(statement)

    total_monthly_expense = 0
    monthly_expense.each do |expense|
      total_monthly_expense += expense[0]
    end

    monthly_expenses_per_day = (total_monthly_expense * 12 / 365.00).round(2)
  end

  def self.total_expenses_per_day
    monthly_expenses_per_day + annual_expenses_per_day
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

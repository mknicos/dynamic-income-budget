require 'budgets_view'
class BudgetsController

  def self.index
    expenses = Expense.total_expenses_per_day.round(2)
    BudgetsView.index(expenses)
  end
end

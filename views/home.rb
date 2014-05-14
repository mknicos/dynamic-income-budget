require 'expenses'
require 'menus'
require 'budgets'

class HomeView

def self.main
print <<EOS
--------------------
What would you like to do?
1. View Your Budget
2. View Your Expenses
3. Add An Expense
--------------------
Type 'Q' to Quit
--------------------
Select a Number:
EOS
  user_selection = gets.chomp
  if user_selection == 'Q' or user_selection == 'q'
    MenusController.quit_selected
  elsif user_selection == '1'
    BudgetsController.index
  elsif user_selection == '2'
    ExpensesController.index
  elsif user_selection == '3'
    ExpensesController.add
  else
    puts 'Invalid Selection'
    HomeView.main
  end
end

def self.display_quit
  puts "Goodbye!"
end

end


class Menu

def self.main_menu
  menu =<<EOS
Welcome!
--------------------
What would you like to do?
1. View Your Budget
2. Add Income
3. Add Expense
--------------------
Type 'Q' to Quit
--------------------
Select a Number:
EOS
  puts menu
  user_selection = gets.chomp
  if user_selection == 'Q' or user_selection == 'q'
    quit_selected
  elsif user_selection == '1'
    return 'view'
  elsif user_selection == '2'
    return 'add_income'
  elsif user_selection == '3'
    return 'add_expense'
  else
    puts 'Invalid Selection'
    display_main_menu
  end
end

def self.quit_selected
  puts "Goodbye!"
end

end

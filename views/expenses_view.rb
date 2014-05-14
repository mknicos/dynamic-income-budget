class ExpensesView
  def self.expense_recurs_menu
print <<EOS
How often does this expense repeat?
--------------------
0. Go Back to Main Menu
1. One Time Expense
2. Weekly
3. Monthly
4. Annually
--------------------
Select A Number:
EOS
end

  def self.index(expenses)
    puts "______EXPENSES______"
    print "\n"
    expenses.each do |expense|
      puts expense[:name].upcase
      print "$" + expense[:amount].to_s + "\s"
      print expense[:recurrance] + "\n"
      puts expense[:description]
      puts "___________________"
      puts "-------------------"
      print "\n"
    end
    next_menu = <<EOS

What would you like to do now?
-----------------------------
1. Add Expense
2. Edit Expense
3. Delete Expense
4. Main Menu
---------------------------
Type 'q' to quit
EOS

  print next_menu
  user_selection = gets.chomp

  case user_selection
  when "1"
    ExpensesController.add
  when "2"
    ExpensesController.update
  when "3"
    ExpensesController.delete
  when "4"
    HomeView.main
  when "q"
    exit
  when "Q"
    exit
  else
    puts "invalid input"
    HomeView.main
  end
  end
end

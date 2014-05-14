require 'home'

class MenusController
  def self.quit_selected
    HomeView.display_quit
    exit
  end

  def self.update_menu
    <<EOS
    What would you like to edit?
    ---------------------------
    1. The Name of the Expense
    2. The Amount of the Expense
    3. Main Menu
    ---------------------------
EOS
  end

  def self.expense_options_menu
    <<EOS
    What would you like to edit?
    ---------------------------
    1. Add Expense
    2. Edit Expense
    3. Delete Expense
    4. Main Menu
    --------------------------
    Type 'q' to quit
EOS
  end

  def self.delete_menu
    puts "--------------------"
    puts "Congrats! One Less Expense!"
    puts "What expense would you like to delete?"
    puts "===================="
    print "\n"
    puts "Type the name of that expense"
    puts "Type 'b' to go back"
    puts "--------------------"
  end

end

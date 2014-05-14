require 'home'
require_relative '../views/expenses_view.rb'

class ExpensesController

  def self.add
    puts "Another Expense?! You need to be more careful"
    puts "What is the name of the new Expense?"
    expense_name = gets.chomp.downcase

    ExpensesView.expense_recurs_menu
    expense_recurs = self.get_expense_recurrance


    puts "What is the amount of this expense?"
    #expenses and incomes will be rounded to nearest whole number
    expense_amount = gets.chomp.to_i.round

    puts "Write a short description of the expense:"
    expense_desc = gets.chomp
    expense = Expense.new(name: expense_name,
                          amount: expense_amount,
                          recurrance: expense_recurs,
                          description: expense_desc)
    if expense.save
      puts "============================="
      puts "#{expense_name} costing $#{expense_amount} #{expense_recurs} has been saved successfully"
      puts "============================="
      HomeView.main
    else
      puts "#{expense_name} was not valid, please try again with a different name"
      self.add
    end
  end
  
  def self.update
    puts "What's the name of the expense you would like to edit?"
    name = gets.chomp.downcase
    print MenusController.update_menu
    selection = gets.chomp
    while selection != "1" and selection != "2" and selection != "3"
      puts "Invalid, Please Make A Selection: "
      selection = gets.chomp
    end
    case selection
    when "1"
      self.edit_name_selected(name)
    when "2"
      self.edit_amount_selected(name)
    when "3"
      HomeView.main
    end
  end

  def self.get_expense_recurrance
    expense_recurs = gets.chomp
    if expense_recurs == "0"
      HomeView.main
    elsif expense_recurs == "1"
      return 'once'
    elsif expense_recurs == "2"
      return 'weekly'
    elsif expense_recurs == "3"
      return 'monthly'
    elsif expense_recurs == "4"
      return 'annually'
    else
      puts "Input Invalid"
      self.get_expense_recurrance
    end
  end

  def self.index
    expenses = Expense.all
    ExpensesView.index(expenses)
    MenusController.expense_options_menu
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
  
  def self.edit_name_selected(old_name)
    expense = Expense.find_by(name: old_name)
    if expense == nil
      puts "I'm Sorry, there is no expense by that name, try again"
      self.update
    else
      puts "Please Enter The New Name: "
      new_name = gets.chomp
      if expense.update(name: new_name)
        puts "This is expense is now named #{new_name}, and has been saved"
      else
      puts "Sorry that name is invalid, or already used, try again"
      self.update
      end
      HomeView.main
    end
  end

  def self.edit_amount_selected(expense_name)
    expense = Expense.find_by(name: expense_name)
    if expense == nil
      puts "I'm Sorry there is no expense by that name, try again"
      self.update
    else
      puts "Please Enter The New Amount for #{expense.name}, which occurs #{expense.recurrance} "
      new_amount = gets.chomp.to_i
      if expense.update(amount: new_amount)
        puts "#{expense_name} amount is now $#{new_amount} and recurs #{expense.recurrance}"
        HomeView.main
      else
        puts "I'm sorry, please try again"
        self.update
      end
    end
  end

  def self.delete
    MenusController.delete_menu
    expense_name = gets.chomp.downcase
    if expense_name == "b"
      HomeView.main
    else
      expense = Expense.find_by(name:expense_name)
      if expense == nil
        puts "There is no expense by that name, try again"
        self.delete
      else
        puts "Are You Sure you would like to delete:"
        puts "#{expense_name} for #{expense.amount} recurring #{expense.recurrance} ?"
        puts "Type 'y' or 'n'"
        confirm = gets.chomp

        case confirm
        when 'n'
          self.index
        when 'y'
          puts "#{expense.name} was deleted"
          expense.delete
          HomeView.main
        else
          puts "Invalid input, try again"
          self.delete
        end
      end
    end
  end
end

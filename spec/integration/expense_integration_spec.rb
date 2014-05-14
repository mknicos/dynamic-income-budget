require_relative '../spec_helper'

describe "Menu Integration" do
  let(:menu_text) do
<<EOS
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
  end
  context "the menu displays on startup" do
    let(:shell_output){ run_budget_with_input("q") }
    it "should print the menu on run" do
      shell_output.should include(menu_text)
    end
  end
  context "the user selects 1" do
    let(:shell_output){ run_budget_with_input("1", "q") }
    it "should display your budget" do
      shell_output.should include("Since you are reading this,")
    end
  end
  context "the user selects 2" do
    let(:shell_output){ run_budget_with_input("2", "q") }
    it "should print the next menu" do
      shell_output.should include("______EXPENSES______")
    end
  end
  context "the users selects add an expense" do
    let(:shell_output){ run_budget_with_input("3", "water", "3", "200", "lets me shower", "q") }
    it "should print the next menu" do
      shell_output.should include("Another Expense?! You need to be more careful")
    end
  end
  context "if the user types in the wrong input" do
    let(:shell_output){ run_budget_with_input("5", "q") }
    it "should print the menu again" do
      shell_output.should include("Invalid Selection")
    end
  end
  context "if the user types in incorrect input, it should allow correct input" do
    let(:shell_output){ run_budget_with_input("4", "2", "q") }
    it "should include the appropriate menu" do
      shell_output.should include("______EXPENSES______")
    end
  end
  context "if the user types in incorrect input multiple times, it should allow correct input" do
    let(:shell_output){ run_budget_with_input("4","", "2", "q") }
    it "should include the appropriate menu" do
      shell_output.should include("______EXPENSES______")
    end
  end
end

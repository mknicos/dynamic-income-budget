require 'spec_helper'
require 'sqlite3'

describe Expense do
  environment = Database.environment
  db = Database.new('db/budget_#{environment}.sqlite3')

  describe "#new" do
   subject { Expense.new("water bill", 100, "annual", "lets me shower")}

   its(:name) { should == "water bill"}
   its(:amount) { should == 100}
   its(:recurrance) { should == "annual"}
   its(:description) { should == "lets me shower"}
  end

  describe "#save" do
    let(:result){ db.execute("SELECT * FROM expenses") }
    let(:expense){ Expense.new("water bill", 100, "annualy", "lets me shower") }
    context "with a valid expense" do
      before do
        expense.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        expense.save
        result.count.should == 1
      end
      it "should record the new id" do
        expense.save
        expense.id.should == result[0]["id"]
      end
      it "should actually save it to the database" do
        expense.save
        result[0]["name"].should == "water bill"
      end
    end
    context "with an invalid expense" do
      before do
        expense.stub(:valid?){ false }
      end
      it "should not save a new expense" do
        expense.save
        result.count.should == 0
      end
    end
  end



  describe "#valid" do
    let(:result) {db.execute("SELECT name FROM expenses")}
    let(:expense1){ Expense.new("water bill", 100, "monthly", "lets me shower") }
    let(:expense2){ Expense.new("electric bill", 200, "monthly", "Nashville Electric Company") }
    let(:expense3){ Expense.new("electric bill", 100, "annualy", "Nashville Electric Company") }

    it "should return true with a unique name" do
        expense2.should be_valid
      end

    it "should return false with a name already in database" do
      expense1.save
      expense2.save
      expense3.should_not be_valid
    end

    it "should return false for name with no valid characters" do
      let(:expense4){ Expense.new("2345", 100, "annualy", "Nashville Electric Company") }
      expense4.should_not be_valid
    end
  end

  describe ".all" do
    it "should return an empty array if the db is empty" do
      Expense.all.should == []
    end

    it "should return all the expenses in the db if its not empty" do
      
    end
  end

  describe ".last" do
  end

  describe ".count" do
  end


end

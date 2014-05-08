require 'spec_helper'
require 'sqlite3'

describe Expense do
  environment = Database.environment
  db = Database.new('db/budget_#{environment}.sqlite3')

  context "#new" do
   subject { Expense.new("water bill", 100, "lets me shower")}

   its(:name) { should == "water bill"}
   its(:amount) { should == 100}
   its(:description) { should == "lets me shower"}
  end

  describe "#save" do
    let(:result){ db.execute("SELECT * FROM expenses") }
    let(:expense){ Expense.new("water bill", 100, "lets me shower") }
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

    context "with a name not in db already" do
    end

    context "with a name already in db" do
    end
    
    context "with a name containing no valid characters" do
    end

  end

  describe ".all" do
  end

  describe ".last" do
  end

  describe ".count" do
  end


end

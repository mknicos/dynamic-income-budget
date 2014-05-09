require_relative '../spec_helper'

describe Expense do

  describe "#new" do
    subject { Expense.new("water bill", 100, "annual", "lets me shower")}

   its(:name) { should == "water bill"}
   its(:amount) { should == 100}
   its(:recurrance) { should == "annual"}
   its(:description) { should == "lets me shower"}
  end

  describe "#save" do
    let(:result){ Database.connection.execute("SELECT * FROM expenses") }
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
        expense.id.should == result[0][0]
      end
      it "should actually save it to the database" do
        expense.save
        result[0][1].should == "water bill"
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

  describe "#create" do
    let(:result){ Database.connection.execute("SELECT * FROM expenses") }
    let(:expense){ Expense.create("water bill", 100, "annualy", "lets me shower") }

    context "with a valid expense" do
      before do
        expense.stub(:valid?){true}
        expense
      end

      it "should record the new id" do
        expected_id = result[0][0]
        expense.id.should == expected_id
      end
      it "should only save one row to the database" do
        Expense.count.should == 1
      end
      it "should be found by name in  the database" do
        Expense.find_by_name("water bill").name.should == "water bill"
      end
      it "should insert a row into database" do
        result.count == 1
      end
    end

    context "with a invalid expense" do
      it "should not save it to the database" do
      end
    end

  end



  describe "#valid" do
    let(:result) {Database.connection.execute("SELECT name FROM expenses")}
    let(:expense1){ Expense.new("water bill", 100, "monthly", "lets me shower") }
    let(:expense2){ Expense.new("electric bill", 200, "monthly", "Nashville Electric Company") }
    let(:expense3){ Expense.new("electric bill", 100, "annualy", "Nashville Electric Company") }
    let(:expense4){ Expense.new("2345", 100, "annualy", "Nashville Electric Company") }

    it "should return true with a unique name" do
        expense2.should be_valid
      end

    it "should return false with a name already in database" do
      expense1.save
      expense2.save
      expense3.should_not be_valid
    end

    it "should return false for name with no valid characters" do
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

  describe "#annual_expenses_per_day" do
    context "with no annual expenses in the databse" do
      it "should return zero with no expenses in database" do
      end
      it "should return zero with other expense types in database" do
      end
    end

    context "with one annual expense in the database" do
      it "should return the one annual expense calc per day with no other expenses" do
      end
      it "should only return the annual expense with other types of expenses in db" do
      end
    end
    context " with many annual expenses in the database" do
      it "should return the sum of all annual expenses divided by num of days in year" do
      end
      it "should return only the sum of annual expenses with other types of expenses in db" do
      end
    end
  end

  describe "#monthly_expenses_per_day" do
    context "with no monthly expenses in the databse" do
      it "should return zero with no expenses in database" do
      end
      it "should return zero with other expense types in database" do
      end
    end

    context "with one monthly expense in the database" do
      it "should return the one monthly expense calc per day with no other expenses" do
      end
      it "should only return the monthly expense with other types of expenses in db" do
      end
    end
    context " with many monthly expenses in the database" do
      it "should return the sum of all monthly expenses divided by num of days in year" do
      end
      it "should return only the sum of monthly expenses with other types of expenses in db" do
      end
    end
  end

  describe ".last" do
  end

  describe ".count" do
    it "should return zero with no expenses in database" do
      Expense.count.should == 0
    end
    it "should return the correct number of rows with multiple injuries in database" do
      Expense.new("water bill", 100, "monthly", "lets me shower").save
      Expense.new("electric bill", 100, "monthly", "lets me see at night").save
      Expense.new("cable bill", 100, "monthly", "lets me watch tv").save
      Expense.count.should == 3
    end
  end

  describe ".find_by_name" do
    context "with no expenses in the database" do
      it "should return nil" do
        Expense.find_by_name("Foo").should be_nil
      end
    end
    context "with expense by that name in the database" do
      let(:water_bill){Expense.new("water bill", 100, "monthly", "lets me shower")}
      before do
        water_bill.save
        Expense.new("electric bill", 100, "monthly", "lets me see at night").save
        Expense.new("cable bill", 100, "monthly", "lets me watch tv").save
      end
      it "should return the injury with that name" do
        Expense.find_by_name("water bill").name.should == "water bill"
      end
      it "should populate the id" do
        Expense.find_by_name("water bill").id.should == water_bill.id
      end
    end
  end
end


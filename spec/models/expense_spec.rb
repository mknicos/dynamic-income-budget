require_relative '../spec_helper'

describe Expense do

  describe "#new" do
    subject {Expense.new(name: "water bill", amount: 100, recurrance: "annually", description: "lets me shower")}

   its(:name) { should == "water bill"}
   its(:amount) { should == 100}
   its(:recurrance) { should == "annually"}
   its(:description) { should == "lets me shower"}
  end

  describe "#save" do
    let(:result){ Expense.connection.execute("SELECT * FROM expenses") }
    let(:expense){ Expense.new(name: "water bill", amount: 100, recurrance: "annually", description: "lets me shower") }
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

  describe "#update_name" do
    let(:original_expense){Expense.create(name: "foo", amount: 100, recurrance: "monthly", description: "foo description")}
    let!(:original_id){original_expense.id}
    context "with an invaild update" do
      before do
        Expense.create(name: "grille", amount: 200, recurrance: "annually", description: "grille description")
        original_expense.update_name("grille")
      end
      it "should not change the name" do
        Expense.find_by_name("foo").should_not be_nil
      end
      it "should not change the number of rows in the database" do
        Expense.count.should == 2
      end
      it "should retain its original id" do
        original_expense.id.should == original_id
      end
      it "should not update to an existing name" do
        grille = Expense.create(name: "grille", amount: 100, recurrance: "annualy", description: "grille description")
        grille.update_name("foo")
        Expense.find_by_name("foo").id.should == original_id
      end
    end
    context "with a valid update" do
      before do
        Expense.create("yam", 250, "annually", "yam description")
        Expense.create("drink", 2000, "annually", "drink description")
        original_expense.update_name("water")
      end
      let(:updated_expense){Expense.find_by_name("water")}
      it "the number of rows in database should not change" do
        Expense.count.should == 3
      end
      it "the updated expense should retain its original id" do
        updated_expense.id.should == original_id
      end
      it "the name should not be nil" do
        updated_expense.should_not be_nil
      end
    end
  end

  describe ".update_amount" do
    let!(:bar){Expense.create("bar", 200, "monthly", "bar description")}
    let(:original_expense){Expense.create("foo", 100, "monthly", "foo description")}
    let!(:original_id){original_expense.id}
    let(:find_original_expense){Expense.find_by_name("foo")}
    context "with a valid amount" do
      it "should update the amount in database" do
        original_expense.update_amount(375)
        find_original_expense.amount.should == 375
      end
      it "should not change the number of rows in the db" do
        Expense.count.should == 2
      end
      it "the updated expense should retain the same id" do
        original_expense.update_amount(375)
        find_original_expense.id.should == original_id
      end
    end
    context "with an invalid amount" do
      it "should not update with a negative amount entered" do
        original_expense.update_amount(-200)
        find_original_expense.amount.should == 100
      end
      it "should not update with any non number characters" do
        original_expense.update_amount("abc")
        find_original_expense.amount.should == 100
      end
      it "should not change the number of rows in the database" do
        original_expense.update_amount("abc")
        Expense.count.should == 2
      end
    end
  end

  describe "#create" do
    let(:result){ Expense.connection.execute("SELECT * FROM expenses") }
    let(:expense){ Expense.create(name: "water bill", amount: 100, recurrance: "annually", description: "lets me shower") }

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

  describe "#remove" do
      let!(:door){Expense.create(name: "door", amount: 225, recurrance: "monthly", description: "bar description")}
      let!(:grille){Expense.create(name: "grille", amount: 175, recurrance: "annually", description: "grille description")}
      let!(:yam){Expense.create(name: "yam", amount: 250, recurrance: "annually", description: "yam description")}
    context "with a valid delete message" do
      before {grille.delete}
      it "should reduce the size of the database" do
        Expense.count.should == 2
      end
      it "should not have a name of that expense in the db" do
        Expense.find_by_name("grille").should be_nil
      end
    end
  end



  describe "#valid" do
    let(:result) {Expense.connection.execute("SELECT name FROM expenses")}
    let(:expense1){ Expense.new(name:"water bill", amount: 100, recurrance: "monthly", description: "lets me shower") }
    let(:expense2){ Expense.new(name:"electric bill", amount: 200, recurrance: "monthly", description: "Nashville Electric Company") }
    let(:expense3){ Expense.new(name:"electric bill", amount: 100, recurrance: "annually", description: "Nashville Electric Company") }
    let(:expense4){ Expense.new(name:"2345", amount: 100, recurrance: "annualy", description: "Nashville Electric Company") }

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
    context "with no expenses in the database" do
      it "should return an empty array if the db is empty" do
        Expense.all.should == []
      end
    end
    context "with multiple expenses in the database" do
      before do
        Expense.create(name: "water bill", amount: 100, recurrance: "annualy", description: "lets me shower")
        Expense.create(name: "cable bill", amount: 100, recurrance: "annualy", description: "lets me shower")
        Expense.create(name: "electric bill", amount: 100, recurrance: "annualy", description: "lets me shower")
        Expense.create(name: "insurance", amount: 100, recurrance: "monthly", description: "lets me shower")
      end

      it "should return the correct number of rows in database" do
        Expense.all.size.should == 4
      end
    end
  end

  describe ".annual_expenses_per_day" do
      let(:foo){Expense.create(name:"foo", amount: 120, recurrance: "monthly", description: "foo description")}
      let(:bar){Expense.create(name:"bar", amount: 95, recurrance: "monthly", description: "bar description")}
      let(:grille){Expense.create(name:"grille", amount: 175, recurrance: "annually", description: "grille description")}
      let(:yam){Expense.create(name:"yam", amount: 250, recurrance: "annually", description: "yam description")}
      let(:drink){Expense.create(name:"drink", amount: 2000, recurrance: "annually", description: "drink description")}
    context "with no annual expenses in the databse" do
      it "should return zero with no expenses in database" do
        Expense.annual_expenses_per_day.should == 0.00
      end
      it "should return zero with other expense types in database" do
        foo
        Expense.annual_expenses_per_day.should == 0.00
      end
    end

    context "with one annual expense in the database" do
      before {grille}
      it "should return the one annual expense calc per day with no other expenses" do
        Expense.annual_expenses_per_day.should == 0.48
      end
      it "should only return the annual expense with other types of expenses in db" do
        foo
        bar
        Expense.annual_expenses_per_day.should == 0.48
      end
    end
    context " with many annual expenses in the database" do
      before {grille; yam; drink}
      it "should return the sum of all annual expenses divided by num of days in year" do
        Expense.annual_expenses_per_day.should == 6.64
      end
      it "should return only the sum of annual expenses with other types of expenses in db" do
        foo
        bar
        Expense.annual_expenses_per_day.should == 6.64
      end
    end
  end

  describe ".monthly_expenses_per_day" do
      let(:foo){Expense.create(name:"foo", amount:120, recurrance:"monthly", description:"foo description")}
      let(:bar){Expense.create(name:"bar", amount:95, recurrance:"monthly", description:"bar description")}
      let(:door){Expense.create(name:"door", amount:225, recurrance:"monthly", description:"bar description")}
      let(:grille){Expense.create(name:"grille", amount:175, recurrance:"annually", description:"grille description")}
      let(:yam){Expense.create(name:"yam", amount:250, recurrance:"annually", description:"yam description")}
      let(:drink){Expense.create(name:"drink", amount:2000, recurrance:"annually", description:"drink description")}
    context "with no monthly expenses in the databse" do
      it "should return zero with no expenses in database" do
        Expense.monthly_expenses_per_day.should == 0.00
      end
      it "should return zero with other expense types in database" do
        grille
        yam
        Expense.monthly_expenses_per_day.should == 0.00
      end
    end

    context "with one expense in the database" do
      before{door}
      it "should return the one monthly expense calc per day with no other expenses" do
        Expense.monthly_expenses_per_day.should == 7.40
      end
      it "should only return the monthly expense with other types of expenses in db" do
        grille
        yam
        Expense.monthly_expenses_per_day.should == 7.40
      end
    end
    context " with many monthly expenses in the database" do
      before {foo; bar; door}
      it "should return monthly expenses calculated on a per day basis" do
        Expense.monthly_expenses_per_day.should == 14.47
      end
      it "should return only monthly expenses with other types of expenses in db" do
        grille
        yam
        drink
        Expense.monthly_expenses_per_day.should == 14.47
      end
    end
  end

  describe ".total_expenses_per_day" do
      let(:foo){Expense.create(name:"foo", amount:120, recurrance:"monthly", description:"foo description")}
      let(:bar){Expense.create(name:"bar", amount:95, recurrance:"monthly", description:"bar description")}
      let(:door){Expense.create(name:"door", amount:225, recurrance:"monthly", description:"bar description")}
      let(:grille){Expense.create(name:"grille", amount:175, recurrance:"annually", description:"grille description")}
      let(:yam){Expense.create(name:"yam", amount:250, recurrance:"annually", description:"yam description")}
      let(:drink){Expense.create(name:"drink", amount:2000, recurrance:"annually", description:"drink description")}

    context "with no expenses in database" do
      it "should return zero" do
        Expense.total_expenses_per_day.should == 0
      end
    end
    context "with only one type of expense in database" do
      it "should return monthly total with only monthly expenses" do
        foo; bar; door;
        Expense.total_expenses_per_day.should == 14.47
      end
      it "should return annual total with only annual expenses" do
        grille; yam; drink;
        Expense.total_expenses_per_day.should == 6.64
      end
    end
    context "with both types of expenses in the database" do
      it "should return total of all expenses in a per day basis" do
        foo; bar; door; grille; yam; drink;
        Expense.total_expenses_per_day.should == 21.11
      end
    end
  end

  describe ".last" do
    context "with no expenses in the database" do
      it "should return nil" do
        Expense.last.should be_nil
      end
    end
    context "with multiple expenses in the database" do
      let(:water_bill){Expense.new(name:"water bill", amount:100, recurrance:"monthly", description:"lets me shower")}
      before do
        Expense.new(name:"electric bill", amount:100, recurrance:"monthly", description:"lets me see at night").save
        Expense.new(name:"cable bill", amount:100, recurrance:"monthly", description:"lets me watch tv").save
        water_bill.save
      end
      it "should return the last one inserted" do
        Expense.last.name.should == "water bill"
      end
      it "should return the last one inserted with id populated" do
        Expense.last.id.should == water_bill.id
      end
    end
  end

  describe ".count" do
    it "should return zero with no expenses in database" do
      Expense.count.should == 0
    end
    it "should return the correct number of rows with multiple injuries in database" do
      Expense.new(name:"water bill", amount:100, recurrance:"monthly", description:"lets me shower").save
      Expense.new(name:"electric bill", amount:100, recurrance:"monthly", description:"lets me see at night").save
      Expense.new(name:"cable bill", amount:100, recurrance:"monthly", description:"lets me watch tv").save
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
      let(:water_bill){Expense.new(name:"water bill", amount:100, recurrance:"monthly", description:"lets me shower").save}
      before do
        water_bill.save
        Expense.new(name:"electric bill", amount:100, recurrance:"monthly", description:"lets me see at night").save
        Expense.new(name:"cable bill", amount:100, recurrance:"monthly", description:"lets me watch tv").save
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


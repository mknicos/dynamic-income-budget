require 'spec_helper'

describe Expense do

  context "#new" do
   subject { Expense.new("Water Bill")}

   its(:name) { should == "Water Bill"}
  end

  #context "#create" do
   #subject { Expense.new("Water Bill")}

  #end
end

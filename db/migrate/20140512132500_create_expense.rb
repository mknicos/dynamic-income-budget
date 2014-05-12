class CreateExpense < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string  :name
      t.integer :amount
      t.string  :recurrance
      t.string  :description
    end
  end
end

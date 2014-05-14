require 'home'

class BudgetsView
  def self.index(expenses_per_day)
  print <<EOS
--------------------
Since you are reading this,
it means you woke up today.
Congrats.
Unfortunately based on your
expenses, you've already
spent $#{expenses_per_day}.
Maybe you should cut back?
-------------------
EOS
  HomeView.main
end
end

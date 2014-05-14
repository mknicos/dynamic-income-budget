$LOAD_PATH << "models"
require 'database'
require 'expense'

Database.environment = 'test'

def run_ltk_with_input(*inputs)
  shell_output = ""
  IO.popen('ENVIRONMENT=test ./budget', 'r+') do |pipe|
    inputs.each do |input|
      pipe.puts input
    end
    pipe.close_write
    shell_output << pipe.read
  end
  shell_output
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.after(:each) do
    Expense.destroy_all
  end
end


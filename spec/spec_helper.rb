require 'bundler/setup'
require 'mongoid-embedded-errors'
require 'database_cleaner'

current_path = File.dirname(__FILE__)
Dir[File.join(current_path, 'support/**/*.rb')].each { |f| require f }
Mongoid.load! File.join(current_path, 'support/mongoid.yml'), :test

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :skip

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.disable_monkey_patching!

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end

require 'bundler/setup'
require 'mongoid-embedded-errors'
require 'database_cleaner'

current_path = File.dirname(__FILE__)
Dir[File.join(current_path, 'support/**/*.rb')].each { |f| require f }
Mongoid.load! File.join(current_path, 'support/mongoid.yml'), :test

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end

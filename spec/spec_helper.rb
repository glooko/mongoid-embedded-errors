require 'bundler/setup'
require 'mongoid-embedded-errors'
require 'database_cleaner'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config.yml'), :test)
require File.join(File.dirname(__FILE__), 'support', 'models')

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end

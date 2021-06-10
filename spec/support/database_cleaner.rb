# frozen_string_literal: true

RSpec.configure do |config|
  DatabaseCleaner.strategy = :deletion
  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end

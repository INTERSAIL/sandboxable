$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sandboxable'
require 'database_cleaner'
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/db/migrate/*.rb'].each { |f| require f }
require 'byebug'

###
# DB connection
###
ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => File.expand_path('../db/testing.sqlite3',__FILE__)
)

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    # run migrations
    CreateSandboxableModel.migrate(:up) unless ActiveRecord::Base.connection.table_exists? 'sandboxable_models'
  end

  config.around(:each) do |single_test|
    DatabaseCleaner.cleaning do
      single_test.run
    end
  end
end

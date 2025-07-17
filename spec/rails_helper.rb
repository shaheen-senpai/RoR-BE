require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner/active_record'

# Add additional requires below this line
require 'shoulda/matchers'
require 'vcr'
require 'webmock/rspec'
require 'simplecov'

# Configure SimpleCov
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/lib/tasks/'
  
  # Group files by type
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Jobs', 'app/jobs'
  add_group 'Serializers', 'app/serializers'
  add_group 'Concerns', 'app/concerns'
  
  # Set minimum coverage percentage
  minimum_coverage 90
  
  # Show coverage for every file (not just the ones with coverage)
  track_files "app/**/*.rb"
  
  # Use HTML and console formatters
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
  ])
  
  # Set coverage directory
  coverage_dir 'coverage'
end

# Define a console formatter for SimpleCov
module SimpleCov
  module Formatter
    class Console
      def format(result)
        puts "\nCoverage Report:"
        puts "  Overall coverage: #{result.covered_percent.round(2)}%"
        
        result.groups.each do |name, files|
          covered = files.covered_percent.round(2) rescue 0
          puts "  #{name}: #{covered}%"
        end
        
        puts "\nTop 5 files with low coverage:"
        result.files.sort_by(&:covered_percent).first(5).each do |file|
          puts "  #{file.filename}: #{file.covered_percent.round(2)}%"
        end
        
        puts "\nGenerated HTML report: #{File.join(SimpleCov.coverage_dir, 'index.html')}"
      end
    end
  end
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Configure VCR
VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
  # Don't record sensitive data
  config.filter_sensitive_data('<API_KEY>') { ENV['API_KEY'] }
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Database Cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Include Factory Bot methods
  config.include FactoryBot::Syntax::Methods

  # Include custom helper modules
  config.include RequestSpecHelper, type: :request

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end

# Configure Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

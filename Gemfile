source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.6"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

gem "bootsnap", "~> 1.16.0", require: false

gem 'concurrent-ruby', '1.3.4'
gem "flipper"
gem 'flipper-redis'
gem "flipper-ui"
gem "paper_trail"
gem "httparty"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

gem 'sidekiq'
gem 'active_model_serializers'

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Memoization
gem "memoist"

# JWT for authentication
gem "jwt"
gem "kaminari"
# For password hashing
gem "bcrypt"

# API documentation
gem "rswag"

# Environment variables
gem "dotenv-rails", groups: [:development, :test]

# CORS handling
gem "rack-cors"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  gem "byebug", "~> 11.1", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 2.23"
  gem "pry-byebug", "~> 3.9"
  gem "pry-rails", "~> 0.3"
  gem "rspec-rails", "~> 5.0"
  gem "timecop", "~> 0.9"
  gem "vcr", "~> 6.1"
  gem "webmock", "~> 3.18"
  gem "rubocop-rails", "~> 2.14", require: false
  gem "rubocop-rspec", "~> 2.11", require: false
  gem "shoulda-matchers"
  gem "standard", "~> 1.12", require: false
  gem "database_cleaner-active_record"
  gem 'rswag-specs'
  gem 'rswag-api'
  gem 'rswag-ui'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "bullet"
  gem "annotate"
end

group :test do
  gem "simplecov", require: false
  gem 'simplecov-console', require: false
end

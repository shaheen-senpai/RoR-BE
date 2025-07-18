namespace :db do
  desc 'Check if database exists'
  task exists: :environment do
    # Check if database exists by establishing a connection
    ActiveRecord::Base.connection
    # If it succeeds, exit with success status
    exit 0
  rescue ActiveRecord::NoDatabaseError
    # If database doesn't exist, exit with error status
    exit 1
  end
end

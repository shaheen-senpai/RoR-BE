# This file contains all the record creation needed to seed the database with default values.
# The data can be loaded with the bin/rails db:seed command or created alongside the database with db:setup.

# Clear existing data to avoid duplicates
puts "Cleaning database..."
User.destroy_all

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
puts "Admin user created with email: #{admin.email}"

# Create regular users
puts "Creating regular users..."
5.times do |i|
  user = User.create!(
    email: "user#{i+1}@example.com",
    password: 'password123',
    password_confirmation: 'password123'
  )
  puts "Regular user created with email: #{user.email}"
  
  # Schedule a background job for each user
  ExampleJob.perform_later(user.id)
  puts "Background job scheduled for user: #{user.email}"
end

# Set up feature flags
puts "Setting up feature flags..."

# Enable premium features for admin
Flipper.enable(:premium_features, admin)
puts "Enabled premium_features flag for admin"

# Create a global feature flag
Flipper.enable(:api_rate_limiting)
puts "Enabled api_rate_limiting flag globally"

# Create a percentage-based rollout feature
Flipper.enable_percentage_of_actors(:new_dashboard, 50)
puts "Enabled new_dashboard flag for 50% of users"

puts "Seed data created successfully!"

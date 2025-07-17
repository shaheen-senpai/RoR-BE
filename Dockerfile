FROM ruby:3.1.1-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git

# Set working directory
WORKDIR /app

# Add Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["rails", "server", "-b", "0.0.0.0"]

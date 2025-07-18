FROM ruby:3.1.1-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git postgresql-client

# Set working directory
WORKDIR /app

# Configure bundler
RUN gem update --system && \
    gem install bundler

# Add Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy the application code
COPY . .

# Copy entrypoint script to root directory and make it executable
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 3000
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Start the application
CMD ["rails", "server", "-b", "0.0.0.0"]

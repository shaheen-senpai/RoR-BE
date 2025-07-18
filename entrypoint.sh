#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

# Check if database exists
if PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -lqt | cut -d \| -f 1 | grep -qw api_boilerplate_development; then
  # Database exists, just run migrations
  echo "Database exists, running migrations"
  bundle exec rails db:migrate
else
  # Database doesn't exist, create it and run migrations
  echo "Database doesn't exist, creating and running migrations"
  bundle exec rails db:create db:migrate db:seed
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

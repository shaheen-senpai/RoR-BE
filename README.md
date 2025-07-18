# Rails API Boilerplate

A reusable, API-only Ruby on Rails boilerplate project with a clean, minimal, non-monolithic architecture. Perfect for quickly bootstrapping new projects or hackathons.

## 🧱 Stack Overview

- **Ruby**: 3.1.1
- **Rails**: 7.0+ (API-only mode)
- **Database**: PostgreSQL (via Docker Compose)
- **Background Jobs**: Sidekiq (via Redis in Docker Compose)
- **Caching**: Redis with RedisCacheStore
- **Auth**: JWT-based user authentication
- **Documentation**: Swagger UI for all exposed APIs
- **ORM**: ActiveRecord
- **API Response Formatting**: ActiveModelSerializers
- **Pagination**: Kaminari
- **Feature Flags**: Flipper + Flipper UI
- **Versioning**: PaperTrail for auditing changes
- **Memoization**: Memoist
- **External APIs**: HTTParty
- **Tokenization**: JWT gem

## 📦 Infrastructure

The project uses Docker Compose to set up the following services:

- `web`: Rails application
- `db`: PostgreSQL database
- `redis`: Redis for caching and Sidekiq
- `sidekiq`: Background job processing

## 🚀 Getting Started

### Prerequisites

- Docker and Docker Compose
- Git

### Setup

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd api-boilerplate
   ```

2. Create a `.env` file in the root directory (or copy from `.env.example` if available):

   ```
   DATABASE_URL=postgres://postgres:postgres@db:5432/api_boilerplate_development
   REDIS_URL=redis://redis:6379/0
   JWT_SECRET_KEY=your_jwt_secret_key_here_please_change_in_production
   RAILS_ENV=development
   ```

3. Start the services using Docker Compose:

   ```bash
   docker compose up -d
   ```

4. Create and migrate the database (in another terminal):

   ```bash
   docker compose exec web rails db:create db:migrate
   ```

5. Seed the database with sample data (optional):
   ```bash
   docker compose exec web rails db:seed
   ```

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication. To authenticate:

1. Create a user or use an existing one
2. Make a POST request to `/api/v1/auth/login` with email and password
3. Use the returned token in the `Authorization` header for subsequent requests

```
Authorization: Bearer your_jwt_token_here
```

## 📚 API Documentation

Swagger UI is available at `/api-docs` when running in development mode.

## 🧪 Testing

The project is set up with RSpec for testing:

```bash
docker-compose exec web bundle exec rspec
```

## 🔧 Development Tools

### Swagger API Documentation

Swagger provides interactive API documentation that allows you to explore and test your API endpoints directly from the browser.

- **Access URL**: `/api-docs` in development mode
- **Configuration**: Located in `spec/swagger_helper.rb` and `swagger/v1/swagger.yaml`
- **Regenerate Documentation**:
  ```bash
  rails rswag:specs:swaggerize
  ```
- **Adding New Endpoints**: Create or modify RSpec tests with Swagger metadata in `spec/requests/api/v1/`
- **Troubleshooting CORS Issues**:
  - Ensure your server URL in `swagger_helper.rb` matches your actual development server
  - Check that CORS is properly configured in `config/initializers/cors.rb`

### Flipper Feature Flags

Flipper allows you to toggle features on and off without deploying new code, perfect for gradual rollouts or A/B testing.

- **Access URL**: `/flipper` in development mode
- **Usage in Code**:

  ```ruby
  # Check if a feature is enabled
  if Flipper.enabled?(:new_feature)
    # New feature code
  else
    # Old feature code
  end

  # Enable for specific users
  Flipper.enable_actor(:new_feature, current_user)
  ```

- **Console Commands**:
  ```ruby
  # In Rails console
  Flipper.enable(:feature_name)  # Enable a feature
  Flipper.disable(:feature_name) # Disable a feature
  Flipper.features               # List all features
  ```

### Sidekiq Background Jobs

Sidekiq processes background jobs asynchronously, improving application performance and user experience.

- **Access URL**: `/sidekiq` in development mode
- **Creating Jobs**:
  ```bash
  rails generate sidekiq:job ProcessData
  ```
- **Enqueuing Jobs**:
  ```ruby
  # In your code
  ProcessDataJob.perform_async(data_id)           # Run asynchronously
  ProcessDataJob.perform_in(5.minutes, data_id)   # Run after delay
  ProcessDataJob.perform_at(5.hours.from_now, data_id) # Run at specific time
  ```
- **Running Sidekiq**:

  ```bash
  # Standalone
  bundle exec sidekiq

  # With Docker
  docker-compose up sidekiq

  # View processed jobs
  docker-compose logs sidekiq
  ```

- **Monitoring**: The Sidekiq dashboard shows real-time stats on processed/failed jobs and allows you to retry failed jobs

## 📁 Project Structure

```
├── app
│   ├── controllers        # API controllers
│   │   └── api
│   │       └── v1         # API version 1 endpoints
│   ├── jobs               # Background jobs
│   ├── models             # Database models
│   └── serializers        # JSON serializers
├── config                 # Rails configuration
├── db                     # Database migrations and seeds
├── docker-compose.yml     # Docker Compose configuration
├── Dockerfile             # Docker configuration
└── swagger                # API documentation
```

## 🎯 Features

- **JWT Authentication**: Secure token-based authentication
- **API Versioning**: Structured for easy API versioning
- **Pagination**: Built-in pagination for list endpoints
- **Feature Flags**: Toggle features using Flipper
- **Background Jobs**: Process tasks asynchronously with Sidekiq
- **Caching**: Redis-based caching for improved performance
- **Audit Trail**: Track changes to models with PaperTrail
- **API Documentation**: Interactive Swagger UI documentation

## 📝 License

This project is available as open source under the terms of the [MIT License](LICENSE).

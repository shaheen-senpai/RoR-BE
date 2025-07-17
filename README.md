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
   docker-compose up
   ```

4. Create and migrate the database (in another terminal):
   ```bash
   docker-compose exec web rails db:create db:migrate
   ```

5. Seed the database with sample data (optional):
   ```bash
   docker-compose exec web rails db:seed
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

- **Sidekiq Dashboard**: Available at `/sidekiq` in development mode
- **Flipper UI**: Available at `/flipper` in development mode

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

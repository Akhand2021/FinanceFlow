# FinanceFlow - Backend

Personal Finance Management Backend API built with NestJS, Prisma, and PostgreSQL.

## Quick Start

### Prerequisites

- Node.js 20+
- PostgreSQL 16+
- Docker (optional)

### Installation

```bash
cd backend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Update DATABASE_URL in .env with your PostgreSQL connection string
```

### Database Setup

```bash
# Generate Prisma client
npm run prisma:generate

# Run migrations
npm run prisma:migrate

# (Optional) Seed database
npm run prisma:seed
```

### Development

```bash
# Start dev server
npm run start:dev

# The API will be available at http://localhost:3000
# Swagger docs at http://localhost:3000/api/docs
```

### Docker Setup

```bash
# Start with Docker Compose
docker-compose up

# This will start both PostgreSQL and the backend server
```

### Available Scripts

```bash
npm run build          # Build for production
npm run start:prod     # Start production server
npm run lint           # Run ESLint
npm run format         # Format code with Prettier
npm test               # Run tests
npm test:cov           # Run tests with coverage
npm run prisma:migrate # Run database migrations
npm run db:push        # Push schema to database (development only)
```

## API Documentation

Once the server is running, visit:

- **Swagger UI**: http://localhost:3000/api/docs

## Project Structure

```
src/
├── common/
│   ├── config/          # Configuration
│   ├── decorators/      # Custom decorators
│   ├── exceptions/      # Custom exceptions
│   ├── filters/         # Exception filters
│   ├── guards/          # Auth guards
│   ├── interceptors/    # Response interceptors
│   ├── pipes/           # Validation pipes
│   └── utils/           # Utility services
├── database/
│   ├── migrations/      # Prisma migrations
│   ├── seeds/           # Database seeds
│   └── prisma.service.ts
└── modules/             # Feature modules (to be implemented)
    ├── auth/
    ├── users/
    ├── accounts/
    ├── transactions/
    ├── categories/
    ├── budgets/
    ├── savings/
    ├── loans/
    ├── reports/
    ├── notifications/
    ├── merchant-rules/
    ├── sms-review/
    ├── ai/
    └── admin/
```

## Environment Variables

See `.env.example` for all available variables.

Key variables:

- `DATABASE_URL`: PostgreSQL connection string
- `JWT_SECRET`: Secret key for JWT tokens
- `JWT_EXPIRATION`: JWT token expiration time
- `PORT`: Server port (default: 3000)

## Architecture

### Clean Architecture

- **Repository Pattern**: Data access abstraction
- **Service Layer**: Business logic
- **DTO Validation**: Input validation with class-validator
- **Dependency Injection**: NestJS built-in DI system

### Database Design

- **UUID Primary Keys**: All entities use UUID
- **Soft Deletes**: Deleted records are marked, not removed
- **Audit Logs**: Track all user actions
- **Timestamps**: Created/Updated timestamps on all entities

## Authentication

- **JWT**: Bearer token authentication
- **Refresh Tokens**: Long-lived tokens for new access tokens
- **Password Hashing**: Bcrypt with salt rounds

## Response Format

All API responses follow a standard format:

```json
{
  "success": true,
  "message": "Success message",
  "data": {
    /* actual data */
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

## Testing

```bash
# Run all tests
npm test

# Watch mode
npm test:watch

# Coverage report
npm test:cov

# End-to-end tests
npm run test:e2e
```

## Contributing

1. Follow the architecture patterns established
2. Create feature modules following the structure
3. Write tests for new features
4. Update Swagger documentation
5. Ensure code passes linting

## License

Proprietary - FinanceFlow

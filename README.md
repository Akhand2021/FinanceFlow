# FinanceFlow - Personal Finance Management

**Track. Save. Grow.**

A production-grade, AI-powered personal finance management application for tracking income, expenses, accounts, budgets, savings goals, loans, and financial health.

## 🚀 Quick Links

- **Mobile App**: [mobile/README.md](mobile/README.md)
- **Backend API**: [backend/README.md](backend/README.md)
- **Documentation**: See individual folders

## 📋 Features

### Core Modules

- **Authentication**: JWT + Refresh tokens, secure login
- **Accounts**: Multiple account management (Bank, Digital Wallet, Cash)
- **Transactions**: Income, Expense, Transfer tracking
- **Categories**: Custom categorization with ML learning
- **Budgets**: Monthly budgets with alerts
- **Savings Goals**: Goal tracking with contributions
- **Loans**: EMI tracking, interest calculation
- **Reports**: Analytics, insights, cash flow charts
- **SMS Detection**: Android SMS transaction detection (AI-powered)
- **Notifications**: Smart reminders and alerts
- **Merchant Rules**: Auto-categorization learning

### Advanced Features

- 📊 Financial Health Score
- 💰 Net Worth Tracking
- 📈 Cash Flow Analysis
- 🤖 AI Transaction Categorization
- 🔐 Biometric & PIN Security
- 🌙 Dark/Light Theme
- 🌐 Multi-currency Support
- 📱 Offline Support
- 🔔 Push Notifications

## 🏗️ Tech Stack

| Layer             | Technology                    |
| ----------------- | ----------------------------- |
| **Mobile**        | Flutter + Riverpod + GoRouter |
| **Backend**       | NestJS + TypeScript           |
| **Database**      | Supabase PostgreSQL           |
| **ORM**           | Prisma                        |
| **Auth**          | JWT + Refresh Tokens          |
| **Charts**        | FL Chart                      |
| **Storage**       | Supabase Storage              |
| **Notifications** | Firebase Cloud Messaging      |
| **Testing**       | Jest + Flutter Test           |
| **Deployment**    | Docker + GitHub Actions       |

## 📁 Folder Structure

```
FinanceFlow/
├── mobile/
│   ├── lib/
│   │   ├── core/
│   │   ├── features/
│   │   ├── config/
│   │   ├── widgets/
│   │   └── main.dart
│   ├── test/
│   ├── pubspec.yaml
│   └── README.md
│
├── backend/
│   ├── src/
│   │   ├── common/
│   │   ├── database/
│   │   ├── modules/
│   │   ├── main.ts
│   │   └── app.module.ts
│   ├── prisma/
│   ├── test/
│   ├── package.json
│   ├── Dockerfile
│   └── README.md
│
├── docker-compose.yml
├── .gitignore
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- **Flutter**: 3.19+
- **Node.js**: 20+
- **PostgreSQL**: 16+
- **Docker**: (optional)

### Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Database setup
npm run prisma:generate
npm run prisma:migrate

# Start development server
npm run start:dev

# Access API: http://localhost:3000
# Swagger docs: http://localhost:3000/api/docs
```

### Mobile Setup

```bash
cd mobile

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run app
flutter run
```

### Docker Setup (Recommended)

```bash
# Start complete stack
docker-compose up

# This starts:
# - PostgreSQL database
# - NestJS backend API
```

## 📚 API Documentation

Once backend is running, visit:

```
http://localhost:3000/api/docs
```

All endpoints follow a standard response format:

```json
{
  "success": true,
  "message": "Success",
  "data": {
    /* data */
  },
  "errors": null,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

## 🏛️ Architecture Principles

✅ **Clean Architecture** - Separation of concerns  
✅ **Domain Driven Design** - Business-focused  
✅ **SOLID Principles** - Maintainable code  
✅ **Repository Pattern** - Data abstraction  
✅ **Dependency Injection** - Loose coupling  
✅ **Modular Design** - Independent features

## 🔐 Security

- ✅ JWT Authentication
- ✅ Password Hashing (Bcrypt)
- ✅ Refresh Token Rotation
- ✅ SQL Injection Protection (Prisma)
- ✅ Row Level Security
- ✅ Audit Logs
- ✅ Soft Deletes
- ✅ Rate Limiting (ready)
- ✅ Biometric Support

## 📊 Database Schema

Key tables:

- `users` - User accounts
- `accounts` - Bank/wallet accounts
- `transactions` - Income/Expense/Transfer
- `categories` - Transaction categories
- `budgets` - Monthly budgets
- `budget_items` - Budget by category
- `saving_goals` - Savings targets
- `goal_contributions` - Goal contributions
- `loans` - Loan tracking
- `loan_payments` - Loan payments
- `merchant_rules` - ML categorization
- `sms_pending` - SMS review queue
- `notifications` - User notifications
- `devices` - Push notification tokens
- `refresh_tokens` - Auth tokens
- `audit_logs` - User actions

## 🧪 Testing

### Backend

```bash
cd backend
npm test                # Run tests
npm test:cov           # Coverage report
npm run test:e2e        # Integration tests
```

### Mobile

```bash
cd mobile
flutter test            # Run tests
flutter test --coverage # Coverage report
```

## 📦 Deployment

### Docker

```bash
docker-compose up -d
```

### Manual

Backend runs on `http://localhost:3000`  
Mobile can be built for iOS/Android/Web

## 🎨 UI/UX Design

- **Modern & Minimal**: Apple-level design
- **Soft Shadows**: Subtle depth
- **Rounded Cards**: 16px border radius
- **Glassmorphism**: Premium effects
- **Smooth Animations**: 300ms transitions
- **Dark/Light Mode**: Full theme support
- **Responsive**: Mobile-first design

## 🤝 Contributing

1. Follow the architecture patterns
2. Create feature modules systematically
3. Write comprehensive tests
4. Update documentation
5. Follow code style guide

## 📝 Module Development

Modules are developed **one at a time** with full implementation:

1. Database Schema
2. Prisma Model
3. DTOs & Validation
4. Entities
5. Repository Pattern
6. Service Layer
7. Controller & Routes
8. Swagger Documentation
9. Unit Tests
10. API Examples
11. Flutter Screens
12. State Management
13. API Integration
14. Error Handling
15. Documentation

Each module must be **production-ready** and scalable for 100,000+ users.

## 📄 License

Proprietary - FinanceFlow Team

---

**Status**: 🚧 Project Setup Complete - Ready for Module Development

**Next Steps**: Implement Authentication Module (foundation for all features)

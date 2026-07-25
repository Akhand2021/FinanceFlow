# FinanceFlow - Mobile App

Personal Finance Management App built with Flutter, Riverpod, and GoRouter.

**Track. Save. Grow.**

## Quick Start

### Prerequisites

- Flutter 3.19+
- Dart 3.3+
- Android SDK (for Android development)
- Xcode (for iOS development on macOS)

### Installation

```bash
cd mobile

# Get dependencies
flutter pub get

# Generate code (if needed)
flutter pub run build_runner build

# Run app
flutter run
```

## Project Structure

```
lib/
├── config/
│   ├── router/
│   │   └── app_router.dart      # GoRouter configuration
│   └── theme/
│       └── app_theme.dart       # UI theme
├── core/
│   ├── models/                  # Core data models
│   ├── repositories/            # Repository interfaces
│   ├── services/                # Core services (API, Auth, etc.)
│   └── providers/               # Riverpod providers
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── transactions/
│   ├── accounts/
│   ├── budgets/
│   ├── loans/
│   ├── savings/
│   ├── reports/
│   ├── notifications/
│   └── settings/
├── widgets/                     # Reusable UI widgets
└── main.dart                    # Entry point
```

## Available Scripts

```bash
flutter pub get              # Install dependencies
flutter pub run build_runner build  # Generate code
flutter run                  # Run on default device
flutter run -d chrome        # Run on web
flutter run -d <device_id>   # Run on specific device
flutter build apk            # Build Android APK
flutter build ios            # Build iOS app
flutter test                 # Run tests
flutter test --coverage      # Run tests with coverage
flutter analyze              # Static analysis
flutter format lib/          # Format code
```

## Architecture

### Clean Architecture

- **Data Layer**: Repositories, API clients
- **Domain Layer**: Entities, use cases
- **Presentation Layer**: Screens, widgets, providers

### State Management with Riverpod

- Functional approach to state
- Provider composition
- Type-safe by default
- Easy testing

### Routing with GoRouter

- Declarative routing
- Deep linking support
- Navigation guards
- Nested routing

## Features

- ✅ Authentication (JWT + Refresh Tokens)
- ✅ Multi-account support
- ✅ Transaction tracking (Income/Expense/Transfer)
- ✅ Budget management
- ✅ Savings goals
- ✅ Loan tracking
- ✅ Reports and analytics
- ✅ SMS transaction detection (Android)
- ✅ Offline support (Hive local database)
- ✅ Dark/Light theme
- ✅ Multi-language support
- ✅ Biometric authentication

## Configuration

### API Configuration

Update `lib/core/services/api_client.dart` with your backend URL:

```dart
const String baseUrl = 'http://your-backend-url/api/v1';
```

### Supabase Configuration

Add your Supabase credentials in `lib/config/supabase_config.dart`:

```dart
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### Firebase Configuration

Add your Google Services files:

- `android/app/google-services.json` (Android)
- `ios/Runner/GoogleService-Info.plist` (iOS)

## Testing

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widgets/

# Integration tests
flutter drive

# Coverage
flutter test --coverage
lcov --list coverage/lcov.info
```

## Building for Production

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## Theme

The app follows Apple-level design standards:

- **Modern & Minimal**: Clean UI with ample whitespace
- **Soft Shadows**: Subtle depth with rounded cards
- **Glassmorphism**: Premium frosted glass effect
- **Smooth Animations**: 300ms + transitions
- **Color Palette**:
  - Primary: #6C63FF (Purple)
  - Secondary: #8E8DFF (Light Purple)
  - Success: #2ECC71 (Green)
  - Danger: #FF5A5F (Red)
  - Warning: #F4B400 (Yellow)
  - Background: #F8F9FC (Light Gray)
  - Dark: #111827 (Almost Black)

## Development Tips

1. **Use DevTools**: `flutter pub global activate devtools && devtools`
2. **Hot Reload**: Press `r` in terminal
3. **Hot Restart**: Press `R` in terminal
4. **Generate Code**: Use `build_runner` for code generation
5. **Format Code**: Run `dart format lib/ -l 80`

## Contributing

1. Follow Flutter best practices
2. Use Riverpod for state management
3. Write tests for new features
4. Update documentation
5. Use meaningful commit messages

## Troubleshooting

### Dependencies conflict

```bash
flutter pub cache clean
flutter pub get
```

### Build cache issues

```bash
flutter clean
flutter pub get
flutter run
```

### Gradle/build issues (Android)

```bash
cd android
./gradlew clean
cd ..
flutter run
```

## License

Proprietary - FinanceFlow

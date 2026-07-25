import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/pin_lock_screen.dart';
import '../../features/navigation/presentation/screens/main_navigation_shell.dart';
import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/budgets/presentation/screens/budgets_screen.dart';
import '../../features/loans/presentation/screens/loans_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/transactions/presentation/screens/recurring_transactions_screen.dart';
import '../../features/merchant_rules/presentation/screens/merchant_rules_screen.dart';
import '../../features/sms_review/presentation/screens/sms_queue_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        name: 'otp',
        builder: (context, state) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: '/auth/pin',
        name: 'pin',
        builder: (context, state) => const PinLockScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const MainNavigationShell(),
      ),
      GoRoute(
        path: '/accounts',
        builder: (context, state) => const AccountsScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/budgets',
        builder: (context, state) => const BudgetsScreen(),
      ),
      GoRoute(
        path: '/loans',
        builder: (context, state) => const LoansScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/recurring',
        builder: (context, state) => const RecurringTransactionsScreen(),
      ),
      GoRoute(
        path: '/rules',
        builder: (context, state) => const MerchantRulesScreen(),
      ),
      GoRoute(
        path: '/sms-queue',
        builder: (context, state) => const SmsQueueScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuthRoute = state.uri.toString().startsWith('/auth');

      if (authState.isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      if (!authState.isAuthenticated && state.uri.toString() == '/dashboard') {
        return '/auth/login';
      }

      return null;
    },
  );
});

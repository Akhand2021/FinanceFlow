import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';
import '../../../reports/presentation/providers/reports_provider.dart';
import '../../../../core/utils/currency_utils.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final accountsAsync = ref.watch(accountsNotifierProvider);
    final transactionsAsync = ref.watch(transactionsNotifierProvider);
    final healthState = ref.watch(healthScoreNotifierProvider);

    final user = authState.user;
    final accounts = accountsAsync.valueOrNull ?? [];
    final transactions = transactionsAsync.valueOrNull ?? [];
    final healthScore = healthState.valueOrNull;

    final totalNetWorth = accounts.fold<double>(0.0, (sum, acc) => sum + acc.balance);

    double totalIncome = 0.0;
    double totalExpense = 0.0;
    for (final tx in transactions) {
      if (tx.type == 'INCOME') {
        totalIncome += tx.amount;
      } else if (tx.type == 'EXPENSE') {
        totalExpense += tx.amount;
      }
    }

    final userCurrency = accounts.isNotEmpty ? accounts.first.currency : 'INR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('FinanceFlow Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(accountsNotifierProvider.notifier).fetchAccounts();
              ref.read(transactionsNotifierProvider.notifier).fetchTransactions();
              ref.read(healthScoreNotifierProvider.notifier).fetchHealthScore();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.firstName ?? 'User'} 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track. Save. Grow.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Real-Time Financial Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Real Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: [
                _buildOverviewCard(
                  context,
                  title: 'Total Net Worth',
                  value: CurrencyUtils.format(totalNetWorth, currency: userCurrency),
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFF6C63FF),
                ),
                _buildOverviewCard(
                  context,
                  title: 'Total Income',
                  value: CurrencyUtils.format(totalIncome, currency: userCurrency),
                  icon: Icons.arrow_downward_rounded,
                  color: const Color(0xFF2ECC71),
                ),
                _buildOverviewCard(
                  context,
                  title: 'Total Expenses',
                  value: CurrencyUtils.format(totalExpense, currency: userCurrency),
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFFE74C3C),
                ),
                _buildOverviewCard(
                  context,
                  title: 'Health Score',
                  value: '${healthScore?.score ?? 85} / 100',
                  icon: Icons.health_and_safety_rounded,
                  color: const Color(0xFFF39C12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/budgets_provider.dart';
import '../../../savings/presentation/providers/savings_provider.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsNotifierProvider);
    final savingsAsync = ref.watch(savingsNotifierProvider);

    final budget = budgetsAsync.value;
    final goals = savingsAsync.value ?? [];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budgets & Savings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Monthly Budgets'),
              Tab(text: 'Savings Goals'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Budgets
            budgetsAsync.isLoading
                ? const Center(child: CircularProgressIndicator())
                : budget == null || budget.items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pie_chart_outline_rounded,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No active budgets for this month',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: budget.items.length,
                        itemBuilder: (context, index) {
                          final item = budget.items[index];
                          final progress = item.limitAmount > 0
                              ? (item.spent / item.limitAmount).clamp(0.0, 1.0)
                              : 0.0;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Category Budget #${index + 1}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '\$${item.spent.toStringAsFixed(0)} / \$${item.limitAmount.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: progress >= 0.9
                                              ? Colors.red
                                              : Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[200],
                                    color: progress >= 0.9
                                        ? Colors.red
                                        : const Color(0xFF6C63FF),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

            // Tab 2: Savings Goals
            savingsAsync.isLoading
                ? const Center(child: CircularProgressIndicator())
                : goals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.savings_outlined,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No savings goals set yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final g = goals[index];
                          final pct = g.targetAmount > 0
                              ? (g.currentAmount / g.targetAmount).clamp(0.0, 1.0)
                              : 0.0;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        g.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '${(pct * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2ECC71)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${g.currentAmount.toStringAsFixed(0)} saved of \$${g.targetAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor: Colors.grey[200],
                                    color: const Color(0xFF2ECC71),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

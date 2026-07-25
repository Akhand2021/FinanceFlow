import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/budgets_provider.dart';
import '../../../savings/presentation/providers/savings_provider.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/toast_utils.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsNotifierProvider);
    final savingsAsync = ref.watch(savingsNotifierProvider);

    final budget = budgetsAsync.valueOrNull;
    final goals = savingsAsync.valueOrNull ?? [];

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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                ref.read(budgetsNotifierProvider.notifier).fetchCurrentBudget();
                ref.read(savingsNotifierProvider.notifier).fetchGoals();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1: Budgets
            RefreshIndicator(
              onRefresh: () async {
                await ref.read(budgetsNotifierProvider.notifier).fetchCurrentBudget();
              },
              child: budgetsAsync.isLoading && budget == null
                  ? const Center(child: CircularProgressIndicator())
                  : budget == null || budget.items.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pie_chart_outline_rounded, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                const Text('No Active Monthly Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                  'Set a spending limit for this month to keep your financial discipline on track.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: const Text('Create Monthly Budget', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                                  onPressed: () => _showAddBudgetDialog(context, ref),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('Current Budget Limit', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('New Budget'),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white),
                                  onPressed: () => _showAddBudgetDialog(context, ref),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...budget.items.map((item) {
                              final progress = item.limitAmount > 0 ? (item.spent / item.limitAmount).clamp(0.0, 1.0) : 0.0;
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            child: Text('Category Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${CurrencyUtils.format(item.spent)} / ${CurrencyUtils.format(item.limitAmount)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: progress >= 0.9 ? const Color(0xFFE74C3C) : const Color(0xFF6C63FF),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.grey[200],
                                        color: progress >= 0.9 ? const Color(0xFFE74C3C) : const Color(0xFF6C63FF),
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
            ),

            // Tab 2: Savings Goals
            RefreshIndicator(
              onRefresh: () async {
                await ref.read(savingsNotifierProvider.notifier).fetchGoals();
              },
              child: savingsAsync.isLoading && goals.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : goals.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.savings_outlined, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                const Text('No Savings Goals Set', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                  'Set savings goals for emergency funds, vacations, or major purchases.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: const Text('Create Goal', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                                  onPressed: () => _showAddGoalDialog(context, ref),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: goals.length,
                          itemBuilder: (context, index) {
                            final g = goals[index];
                            final pct = g.targetAmount > 0 ? (g.currentAmount / g.targetAmount).clamp(0.0, 1.0) : 0.0;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(g.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${(pct * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2ECC71)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${CurrencyUtils.format(g.currentAmount)} saved of ${CurrencyUtils.format(g.targetAmount)}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create Monthly Budget', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Total Monthly Budget Limit', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white),
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount <= 0) {
                ToastUtils.showError(context, 'Please enter a valid budget amount.');
                return;
              }

              try {
                await ref.read(budgetsNotifierProvider.notifier).createBudget({
                  'name': 'Monthly Budget',
                  'amount': amount,
                  'month': DateTime.now().toIso8601String(),
                  'alertThreshold': 80,
                  'items': [],
                });
                if (context.mounted) {
                  ToastUtils.showSuccess(context, 'Monthly Budget created!');
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ToastUtils.showError(context, 'Failed to create budget: ${e.toString()}');
                }
              }
            },
            child: const Text('Save Budget'),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create Savings Goal', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Goal Name (e.g. Emergency Fund, New Car)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Target Savings Amount', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71), foregroundColor: Colors.white),
            onPressed: () async {
              final name = nameController.text.trim();
              final target = double.tryParse(targetController.text) ?? 0.0;
              if (name.isEmpty || target <= 0) {
                ToastUtils.showError(context, 'Please enter valid goal name and target amount.');
                return;
              }

              try {
                await ref.read(savingsNotifierProvider.notifier).createGoal({
                  'name': name,
                  'targetAmount': target,
                  'currentAmount': 0.0,
                  'priority': 'HIGH',
                });
                if (context.mounted) {
                  ToastUtils.showSuccess(context, 'Savings Goal $name created!');
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ToastUtils.showError(context, 'Failed to create goal: ${e.toString()}');
                }
              }
            },
            child: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }
}

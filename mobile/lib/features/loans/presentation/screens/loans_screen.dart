import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loans_provider.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/toast_utils.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansNotifierProvider);
    final loans = loansAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans & EMIs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(loansNotifierProvider.notifier).fetchLoans();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddLoanDialog(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(loansNotifierProvider.notifier).fetchLoans();
        },
        child: loansAsync.isLoading && loans.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : loans.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No Active Loans or EMIs',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Track home loans, car loans, personal debts, or money borrowed/lent.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add Loan', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _showAddLoanDialog(context, ref),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      final loan = loans[index];
                      final pct = loan.progressPercentage / 100;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    loan.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  if (loan.emiAmount != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'EMI ${CurrencyUtils.format(loan.emiAmount!)}',
                                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Remaining Balance', style: TextStyle(color: Colors.grey)),
                                  Text(
                                    CurrencyUtils.format(loan.currentAmount),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: pct.clamp(0.0, 1.0),
                                backgroundColor: Colors.grey[200],
                                color: const Color(0xFF6C63FF),
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
    );
  }

  void _showAddLoanDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final principalController = TextEditingController();
    final rateController = TextEditingController();
    final emiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Loan / Debt', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Loan Name (e.g. Home Loan)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: principalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Principal Amount', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Interest Rate (%)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly EMI (optional)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white),
            onPressed: () async {
              final name = nameController.text.trim();
              final principal = double.tryParse(principalController.text) ?? 0.0;
              final rate = double.tryParse(rateController.text) ?? 0.0;
              final emi = double.tryParse(emiController.text);

              if (name.isEmpty || principal <= 0) {
                ToastUtils.showError(context, 'Please enter valid loan name and principal amount.');
                return;
              }

              try {
                await ref.read(loansNotifierProvider.notifier).createLoan({
                  'name': name,
                  'type': 'PERSONAL_LOAN',
                  'principal': principal,
                  'currentAmount': principal,
                  'interestRate': rate,
                  if (emi != null) 'emiAmount': emi,
                  'startDate': DateTime.now().toIso8601String(),
                });
                if (context.mounted) {
                  ToastUtils.showSuccess(context, 'Loan $name added successfully!');
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ToastUtils.showError(context, 'Failed to save loan: ${e.toString()}');
                }
              }
            },
            child: const Text('Save Loan'),
          ),
        ],
      ),
    );
  }
}

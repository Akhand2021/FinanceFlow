import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transactions_provider.dart';
import '../widgets/add_transaction_modal.dart';
import '../../../../core/utils/currency_utils.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsNotifierProvider);
    final allTransactions = transactionsAsync.valueOrNull ?? [];

    final transactions = _selectedFilter == 'ALL'
        ? allTransactions
        : allTransactions.where((t) => t.type == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions & Activity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(transactionsNotifierProvider.notifier).fetchTransactions();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddTransactionModal(),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(transactionsNotifierProvider.notifier).fetchTransactions();
        },
        child: Column(
          children: [
            // Filter Pills (ALL / EXPENSE / INCOME / TRANSFER)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'All Activity'),
                  const SizedBox(width: 8),
                  _buildFilterChip('EXPENSE', 'Expense'),
                  const SizedBox(width: 8),
                  _buildFilterChip('INCOME', 'Income'),
                  const SizedBox(width: 8),
                  _buildFilterChip('TRANSFER', 'Transfer'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: transactionsAsync.isLoading && allTransactions.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : transactions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                const Text(
                                  'No transactions recorded yet',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Recorded transactions from your accounts and SMS will appear here automatically.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C63FF),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => const AddTransactionModal(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final tx = transactions[index];
                            final isExpense = tx.type == 'EXPENSE';
                            final isIncome = tx.type == 'INCOME';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              elevation: 0.5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                leading: CircleAvatar(
                                  backgroundColor: isExpense
                                      ? const Color(0xFFE74C3C).withValues(alpha: 0.12)
                                      : isIncome
                                          ? const Color(0xFF2ECC71).withValues(alpha: 0.12)
                                          : const Color(0xFF3498DB).withValues(alpha: 0.12),
                                  child: Icon(
                                    isExpense
                                        ? Icons.arrow_upward_rounded
                                        : isIncome
                                            ? Icons.arrow_downward_rounded
                                            : Icons.swap_horiz_rounded,
                                    color: isExpense
                                        ? const Color(0xFFE74C3C)
                                        : isIncome
                                            ? const Color(0xFF2ECC71)
                                            : const Color(0xFF3498DB),
                                  ),
                                ),
                                title: Text(
                                  tx.description?.isNotEmpty == true
                                      ? tx.description!
                                      : (tx.merchant?.isNotEmpty == true ? tx.merchant! : tx.type),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Text(
                                  '${tx.merchant ?? 'General'} • ${tx.date.toString().substring(0, 10)}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                trailing: Text(
                                  '${isExpense ? '-' : (isIncome ? '+' : '')}${CurrencyUtils.format(tx.amount)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isExpense
                                        ? const Color(0xFFE74C3C)
                                        : isIncome
                                            ? const Color(0xFF2ECC71)
                                            : Colors.blue[700],
                                  ),
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

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: const Color(0xFF6C63FF).withValues(alpha: 0.15),
      checkmarkColor: const Color(0xFF6C63FF),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = value);
        }
      },
    );
  }
}

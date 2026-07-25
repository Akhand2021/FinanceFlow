import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/accounts_provider.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/toast_utils.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsNotifierProvider);
    final accounts = accountsAsync.valueOrNull ?? [];
    final totalBalance = accounts.fold<double>(0.0, (sum, acc) => sum + acc.balance);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts & Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(accountsNotifierProvider.notifier).fetchAccounts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_card_rounded),
            onPressed: () => _showAddAccountDialog(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(accountsNotifierProvider.notifier).fetchAccounts();
        },
        child: accountsAsync.isLoading && accounts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Total Balance Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF3B38A8)],
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
                        const Text(
                          'Total Net Liquid Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            CurrencyUtils.format(totalBalance, currency: accounts.isNotEmpty ? accounts.first.currency : 'INR'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${accounts.length} Accounts Connected',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Your Accounts',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _showAddAccountDialog(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (accounts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No financial accounts connected yet',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your bank accounts, credit cards, or digital wallets to automatically track liquid net worth.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _showAddAccountDialog(context, ref),
                            child: const Text('Connect First Account'),
                          ),
                        ],
                      ),
                    )
                  else
                    ...accounts.map(
                      (account) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                            child: const Icon(Icons.account_balance_rounded, color: Color(0xFF6C63FF)),
                          ),
                          title: Text(
                            account.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('${account.type} • ${account.currency}'),
                          trailing: Text(
                            CurrencyUtils.format(account.balance, currency: account.currency),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: account.balance >= 0 ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();
    String selectedType = 'BANK';
    String selectedCurrency = 'INR';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Connect New Account', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  hintText: 'e.g. HDFC Bank, Cash Wallet',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'Account Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'BANK', child: Text('Bank Account (Checking / Savings)')),
                  DropdownMenuItem(value: 'CREDIT_CARD', child: Text('Credit Card')),
                  DropdownMenuItem(value: 'DIGITAL_WALLET', child: Text('Digital Wallet (Paytm / PhonePe)')),
                  DropdownMenuItem(value: 'CASH', child: Text('Cash Wallet')),
                  DropdownMenuItem(value: 'UPI', child: Text('UPI Account')),
                  DropdownMenuItem(value: 'INVESTMENT', child: Text('Investment Portfolio')),
                ],
                onChanged: (val) => setState(() => selectedType = val!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCurrency,
                decoration: const InputDecoration(labelText: 'Currency', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'INR', child: Text('INR (₹) - Indian Rupee')),
                  DropdownMenuItem(value: 'USD', child: Text('USD (\$) - US Dollar')),
                  DropdownMenuItem(value: 'EUR', child: Text('EUR (€) - Euro')),
                  DropdownMenuItem(value: 'GBP', child: Text('GBP (£) - British Pound')),
                  DropdownMenuItem(value: 'CAD', child: Text('CAD (C\$) - Canadian Dollar')),
                  DropdownMenuItem(value: 'AUD', child: Text('AUD (A\$) - Australian Dollar')),
                ],
                onChanged: (val) => setState(() => selectedCurrency = val!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: balanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Initial Balance',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                final balance = double.tryParse(balanceController.text) ?? 0.0;
                if (name.isEmpty) {
                  ToastUtils.showError(context, 'Please enter an account name.');
                  return;
                }

                try {
                  await ref.read(accountsNotifierProvider.notifier).addAccount({
                    'name': name,
                    'type': selectedType,
                    'balance': balance,
                    'currency': selectedCurrency,
                  });
                  if (context.mounted) {
                    ToastUtils.showSuccess(context, 'Account $name connected successfully!');
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ToastUtils.showError(context, 'Failed to save account: ${e.toString()}');
                  }
                }
              },
              child: const Text('Connect Account'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/accounts_provider.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsNotifierProvider);
    final accounts = accountsAsync.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts & Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_rounded),
            onPressed: () {
              _showAddAccountDialog(context, ref);
            },
          ),
        ],
      ),
      body: accountsAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : accounts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No accounts added yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Account'),
                        onPressed: () => _showAddAccountDialog(context, ref),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                          child: const Icon(Icons.account_balance_wallet,
                              color: Color(0xFF6C63FF)),
                        ),
                        title: Text(
                          account.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${account.type} • ${account.currency}'),
                        trailing: Text(
                          '\$${account.balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: account.balance >= 0
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Account Name (e.g. Chase Bank)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Initial Balance'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final balance = double.tryParse(balanceController.text) ?? 0.0;
              if (name.isNotEmpty) {
                ref.read(accountsNotifierProvider.notifier).addAccount({
                  'name': name,
                  'type': 'CHECKING',
                  'balance': balance,
                  'currency': 'USD',
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

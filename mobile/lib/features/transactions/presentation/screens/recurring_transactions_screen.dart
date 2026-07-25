import 'package:flutter/material.dart';

class RecurringTransactionsScreen extends StatefulWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  State<RecurringTransactionsScreen> createState() => _RecurringTransactionsScreenState();
}

class _RecurringTransactionsScreenState extends State<RecurringTransactionsScreen> {
  final List<Map<String, dynamic>> _recurringList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recurring Subscriptions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Paused'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddRecurringDialog(),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _recurringList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.repeat_on_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No Recurring Subscriptions',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Track monthly Netflix, Spotify, Gym, or bill payments.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add Subscription', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _showAddRecurringDialog(),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _recurringList.length,
                    itemBuilder: (context, index) {
                      final item = _recurringList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF6C63FF),
                            child: Icon(Icons.repeat, color: Colors.white),
                          ),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Next due: ${item['next']}'),
                          trailing: Text(
                            item['amount'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
            const Center(child: Text('No paused recurring subscriptions')),
          ],
        ),
      ),
    );
  }

  void _showAddRecurringDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Subscription', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Subscription Name (e.g. Netflix, Gym)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Amount', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white),
            onPressed: () {
              final name = nameController.text.trim();
              final amount = amountController.text.trim();
              if (name.isNotEmpty && amount.isNotEmpty) {
                setState(() {
                  _recurringList.add({
                    'name': name,
                    'amount': '₹$amount',
                    'next': 'Next Month',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save Subscription'),
          ),
        ],
      ),
    );
  }
}

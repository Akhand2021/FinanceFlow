import 'package:flutter/material.dart';

class RecurringTransactionsScreen extends StatelessWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recurringList = [
      {'name': 'Netflix', 'amount': '₹649', 'next': 'Next: 26 May 2024', 'icon': Icons.movie},
      {'name': 'Gym Membership', 'amount': '₹1,200', 'next': 'Next: 28 May 2024', 'icon': Icons.fitness_center},
      {'name': 'Spotify', 'amount': '₹119', 'next': 'Next: 18 May 2024', 'icon': Icons.music_note},
      {'name': 'Zomato Pro', 'amount': '₹350', 'next': 'Next: 10 Jun 2024', 'icon': Icons.restaurant},
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recurring Transactions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Paused'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recurringList.length,
              itemBuilder: (context, index) {
                final item = recurringList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withValues(alpha: 0.15),
                      child: Icon(item['icon'] as IconData, color: Colors.red),
                    ),
                    title: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['next'] as String),
                    trailing: Text(
                      item['amount'] as String,
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
}

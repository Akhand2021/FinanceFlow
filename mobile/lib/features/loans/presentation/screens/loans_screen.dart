import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loans_provider.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansNotifierProvider);
    final loans = loansAsync.valueOrNull ?? [];

    final sampleLoans = [
      {
        'name': 'Home Loan',
        'principal': '₹20,000,000',
        'remaining': '₹12,48,000',
        'rate': '8.5%',
        'emi': '₹18,225',
      },
      {
        'name': 'Car Loan',
        'principal': '₹500,000',
        'remaining': '₹2,80,000',
        'rate': '9.2%',
        'emi': '₹11,400',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans & EMIs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: loansAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: loans.isNotEmpty ? loans.length : sampleLoans.length,
              itemBuilder: (context, index) {
                final name = loans.isNotEmpty ? loans[index].name : sampleLoans[index]['name'];
                final remaining = loans.isNotEmpty
                    ? '₹${loans[index].currentAmount.toStringAsFixed(0)}'
                    : sampleLoans[index]['remaining'];
                final emi = loans.isNotEmpty
                    ? '₹${loans[index].emiAmount?.toStringAsFixed(0) ?? '0'}'
                    : sampleLoans[index]['emi'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'EMI $emi',
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Remaining Balance',
                                style: TextStyle(color: Colors.grey)),
                            Text(remaining as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(
                          value: 0.62,
                          backgroundColor: Colors.grey,
                          color: Color(0xFF6C63FF),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

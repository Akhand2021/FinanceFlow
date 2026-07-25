import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sms_review_provider.dart';
import '../../../../core/utils/toast_utils.dart';

class SmsQueueScreen extends ConsumerWidget {
  const SmsQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smsAsync = ref.watch(smsQueueNotifierProvider);
    final smsList = smsAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending SMS Queue 📲'),
      ),
      body: smsAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : smsList.isEmpty
              ? const Center(child: Text('No pending SMS transactions to review'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: smsList.length,
                  itemBuilder: (context, index) {
                    final item = smsList[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF6C63FF),
                          child: Icon(Icons.sms, color: Colors.white),
                        ),
                        title: Text(item.merchant,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item.time),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${item.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () {
                                ref.read(smsQueueNotifierProvider.notifier).removeSms(item.id);
                                ToastUtils.showSuccess(
                                    context, 'Transaction approved & added!');
                              },
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

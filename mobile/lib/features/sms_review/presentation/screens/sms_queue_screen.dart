import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sms_review_provider.dart';
import '../../../../core/utils/currency_utils.dart';
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
      body: smsAsync.isLoading && smsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : smsList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sms_failed_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'No Pending SMS to Review',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'When your bank sends transaction SMS notifications, FinanceFlow will parse and queue them here for 1-tap approval.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: smsList.length,
                  itemBuilder: (context, index) {
                    final item = smsList[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF6C63FF),
                          child: Icon(Icons.sms, color: Colors.white),
                        ),
                        title: Text(item.merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item.time),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrencyUtils.format(item.amount),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () {
                                ref.read(smsQueueNotifierProvider.notifier).removeSms(item.id);
                                ToastUtils.showSuccess(context, 'Transaction approved and recorded!');
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

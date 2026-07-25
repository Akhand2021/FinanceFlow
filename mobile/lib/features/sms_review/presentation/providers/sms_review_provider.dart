import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingSmsItem {
  final String id;
  final String merchant;
  final double amount;
  final String time;

  const PendingSmsItem({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.time,
  });
}

class SmsQueueNotifier extends StateNotifier<AsyncValue<List<PendingSmsItem>>> {
  SmsQueueNotifier()
      : super(AsyncValue.data(const [
          PendingSmsItem(id: '1', merchant: 'Swiggy', amount: 450, time: '12 May, 12:30 PM'),
          PendingSmsItem(id: '2', merchant: 'Amazon Pay', amount: 1290, time: '11 May, 10:20 AM'),
          PendingSmsItem(id: '3', merchant: 'Uber', amount: 320, time: '11 May, 09:10 AM'),
          PendingSmsItem(id: '4', merchant: 'Zomato', amount: 280, time: '10 May, 08:00 PM'),
        ]));

  void removeSms(String id) {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((item) => item.id != id).toList());
  }
}

final smsQueueNotifierProvider = StateNotifierProvider<
    SmsQueueNotifier, AsyncValue<List<PendingSmsItem>>>((ref) {
  return SmsQueueNotifier();
});

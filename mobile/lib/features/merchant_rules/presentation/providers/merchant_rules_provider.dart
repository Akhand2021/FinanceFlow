import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantRuleItem {
  final String id;
  final String merchant;
  final String category;

  const MerchantRuleItem({
    required this.id,
    required this.merchant,
    required this.category,
  });
}

class MerchantRulesNotifier extends StateNotifier<AsyncValue<List<MerchantRuleItem>>> {
  MerchantRulesNotifier()
      : super(AsyncValue.data(const [
          MerchantRuleItem(id: '1', merchant: 'Swiggy', category: 'Food'),
          MerchantRuleItem(id: '2', merchant: 'Uber', category: 'Travel'),
          MerchantRuleItem(id: '3', merchant: 'Amazon', category: 'Shopping'),
          MerchantRuleItem(id: '4', merchant: 'Zomato', category: 'Food'),
          MerchantRuleItem(id: '5', merchant: 'BigBasket', category: 'Groceries'),
          MerchantRuleItem(id: '6', merchant: 'Salary', category: 'Income'),
        ]));

  void addRule(String merchant, String category) {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([
      ...current,
      MerchantRuleItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        merchant: merchant,
        category: category,
      ),
    ]);
  }
}

final merchantRulesNotifierProvider = StateNotifierProvider<
    MerchantRulesNotifier, AsyncValue<List<MerchantRuleItem>>>((ref) {
  return MerchantRulesNotifier();
});

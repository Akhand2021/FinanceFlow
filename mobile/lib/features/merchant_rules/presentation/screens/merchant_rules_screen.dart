import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/merchant_rules_provider.dart';
import '../../../../core/utils/toast_utils.dart';

class MerchantRulesScreen extends ConsumerWidget {
  const MerchantRulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(merchantRulesNotifierProvider);
    final rules = rulesAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Rules Engine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddRuleDialog(context, ref),
          ),
        ],
      ),
      body: rulesAsync.isLoading && rules.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : rules.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_fix_high_rounded, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'No Auto-Categorization Rules',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create rules to automatically categorize SMS and card transactions (e.g. Swiggy ➔ Food, Uber ➔ Travel).',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Create First Rule', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _showAddRuleDialog(context, ref),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rules.length,
                  itemBuilder: (context, index) {
                    final rule = rules[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF6C63FF),
                          child: Icon(Icons.auto_fix_high, color: Colors.white),
                        ),
                        title: Text(
                          '${rule.merchant} ➔ ${rule.category}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Auto-categorize transactions'),
                        trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddRuleDialog(BuildContext context, WidgetRef ref) {
    final merchantController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Merchant Rule', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: merchantController,
              decoration: const InputDecoration(labelText: 'Merchant Name (e.g. Swiggy, Uber)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category (e.g. Food, Travel)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white),
            onPressed: () {
              final merchant = merchantController.text.trim();
              final category = categoryController.text.trim();
              if (merchant.isNotEmpty && category.isNotEmpty) {
                ref.read(merchantRulesNotifierProvider.notifier).addRule(merchant, category);
                ToastUtils.showSuccess(context, 'Rule created: $merchant ➔ $category');
                Navigator.pop(context);
              }
            },
            child: const Text('Save Rule'),
          ),
        ],
      ),
    );
  }
}

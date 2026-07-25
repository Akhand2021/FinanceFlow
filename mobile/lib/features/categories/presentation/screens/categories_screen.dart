import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/categories_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesNotifierProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Add category dialog
              },
            ),
          ],
        ),
        body: categoriesAsync.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildCategoryList(categories.where((c) => c.type == 'EXPENSE').toList()),
                  _buildCategoryList(categories.where((c) => c.type == 'INCOME').toList()),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryList(List<dynamic> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No categories available'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final cat = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.15),
              child: const Icon(Icons.category, color: Color(0xFF6C63FF)),
            ),
            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}

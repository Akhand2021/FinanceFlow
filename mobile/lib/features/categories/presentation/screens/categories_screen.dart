import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/categories_provider.dart';
import '../../../../core/utils/toast_utils.dart';

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
          title: const Text('Category Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expense Categories'),
              Tab(text: 'Income Categories'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                ref.read(categoriesNotifierProvider.notifier).fetchCategories();
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddCategoryDialog(context, ref),
            ),
          ],
        ),
        body: categoriesAsync.isLoading && categories.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildCategoryList(context, ref, categories.where((c) => c.type == 'EXPENSE').toList()),
                  _buildCategoryList(context, ref, categories.where((c) => c.type == 'INCOME').toList()),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, WidgetRef ref, List<dynamic> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text('No Categories Configured', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Create custom categories to organize your expenses and income streams.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Category', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                onPressed: () => _showAddCategoryDialog(context, ref),
              ),
            ],
          ),
        ),
      );
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
            subtitle: Text(cat.type),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                ref.read(categoriesNotifierProvider.notifier).deleteCategory(cat.id);
                ToastUtils.showSuccess(context, 'Category deleted.');
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String selectedType = 'EXPENSE';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Category', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name (e.g. Groceries, Freelance)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'EXPENSE', child: Text('Expense')),
                  DropdownMenuItem(value: 'INCOME', child: Text('Income')),
                ],
                onChanged: (val) => setState(() => selectedType = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ToastUtils.showError(context, 'Please enter a category name.');
                  return;
                }

                try {
                  await ref.read(categoriesNotifierProvider.notifier).addCategory({
                    'name': name,
                    'type': selectedType,
                  });
                  if (context.mounted) {
                    ToastUtils.showSuccess(context, 'Category $name created!');
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ToastUtils.showError(context, 'Failed to create category: ${e.toString()}');
                  }
                }
              },
              child: const Text('Create Category'),
            ),
          ],
        ),
      ),
    );
  }
}

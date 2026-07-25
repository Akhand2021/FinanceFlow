import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/budget_entity.dart';
import '../../data/datasources/budgets_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final budgetsDatasourceProvider = Provider<BudgetsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return BudgetsRemoteDatasourceImpl(dio: dio);
});

class BudgetsNotifier extends StateNotifier<AsyncValue<BudgetEntity?>> {
  final BudgetsRemoteDatasource datasource;

  BudgetsNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchCurrentBudget();
  }

  Future<void> fetchCurrentBudget() async {
    state = const AsyncValue.loading();
    try {
      final budget = await datasource.getCurrentBudget();
      state = AsyncValue.data(budget);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBudget(Map<String, dynamic> data) async {
    try {
      await datasource.createBudget(data);
      await fetchCurrentBudget();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await datasource.deleteBudget(id);
      await fetchCurrentBudget();
    } catch (e) {
      rethrow;
    }
  }
}

final budgetsNotifierProvider =
    StateNotifierProvider<BudgetsNotifier, AsyncValue<BudgetEntity?>>((ref) {
  final datasource = ref.watch(budgetsDatasourceProvider);
  return BudgetsNotifier(datasource: datasource);
});

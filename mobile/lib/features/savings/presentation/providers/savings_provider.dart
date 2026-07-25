import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/saving_goal_entity.dart';
import '../../data/datasources/savings_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final savingsDatasourceProvider = Provider<SavingsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return SavingsRemoteDatasourceImpl(dio: dio);
});

class SavingsNotifier extends StateNotifier<AsyncValue<List<SavingGoalEntity>>> {
  final SavingsRemoteDatasource datasource;

  SavingsNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    state = const AsyncValue.loading();
    try {
      final goals = await datasource.getGoals();
      state = AsyncValue.data(goals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createGoal(Map<String, dynamic> data) async {
    try {
      await datasource.createGoal(data);
      await fetchGoals();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addContribution(String id, Map<String, dynamic> data) async {
    try {
      await datasource.addContribution(id, data);
      await fetchGoals();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await datasource.deleteGoal(id);
      await fetchGoals();
    } catch (e) {
      rethrow;
    }
  }
}

final savingsNotifierProvider =
    StateNotifierProvider<SavingsNotifier, AsyncValue<List<SavingGoalEntity>>>((ref) {
  final datasource = ref.watch(savingsDatasourceProvider);
  return SavingsNotifier(datasource: datasource);
});

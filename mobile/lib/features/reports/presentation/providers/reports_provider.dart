import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/financial_health_score_entity.dart';
import '../../data/datasources/reports_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final reportsDatasourceProvider = Provider<ReportsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ReportsRemoteDatasourceImpl(dio: dio);
});

class HealthScoreNotifier extends StateNotifier<AsyncValue<FinancialHealthScoreEntity>> {
  final ReportsRemoteDatasource datasource;

  HealthScoreNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchHealthScore();
  }

  Future<void> fetchHealthScore() async {
    state = const AsyncValue.loading();
    try {
      final score = await datasource.getHealthScore();
      state = AsyncValue.data(score);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final healthScoreNotifierProvider =
    StateNotifierProvider<HealthScoreNotifier, AsyncValue<FinancialHealthScoreEntity>>((ref) {
  final datasource = ref.watch(reportsDatasourceProvider);
  return HealthScoreNotifier(datasource: datasource);
});

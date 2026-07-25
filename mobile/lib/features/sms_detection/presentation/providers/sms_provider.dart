import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sms_pending_entity.dart';
import '../../data/datasources/sms_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final smsDatasourceProvider = Provider<SmsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return SmsRemoteDatasourceImpl(dio: dio);
});

class SmsNotifier extends StateNotifier<AsyncValue<List<SmsPendingEntity>>> {
  final SmsRemoteDatasource datasource;

  SmsNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchPendingSms();
  }

  Future<void> fetchPendingSms() async {
    state = const AsyncValue.loading();
    try {
      final list = await datasource.getPendingSms();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> processSms(String id, String action, {String? accountId, String? categoryId}) async {
    try {
      await datasource.processSms(id, action, accountId: accountId, categoryId: categoryId);
      await fetchPendingSms();
    } catch (e) {
      rethrow;
    }
  }
}

final smsNotifierProvider =
    StateNotifierProvider<SmsNotifier, AsyncValue<List<SmsPendingEntity>>>((ref) {
  final datasource = ref.watch(smsDatasourceProvider);
  return SmsNotifier(datasource: datasource);
});

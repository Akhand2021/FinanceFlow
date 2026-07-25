import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../data/datasources/settings_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final settingsDatasourceProvider = Provider<SettingsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return SettingsRemoteDatasourceImpl(dio: dio);
});

class SettingsNotifier extends StateNotifier<AsyncValue<UserSettingsEntity>> {
  final SettingsRemoteDatasource datasource;

  SettingsNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await datasource.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSettings(Map<String, dynamic> data) async {
    try {
      final updated = await datasource.updateSettings(data);
      state = AsyncValue.data(updated);
    } catch (e) {
      rethrow;
    }
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettingsEntity>>((ref) {
  final datasource = ref.watch(settingsDatasourceProvider);
  return SettingsNotifier(datasource: datasource);
});

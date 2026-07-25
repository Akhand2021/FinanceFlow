import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/account_entity.dart';
import '../../data/datasources/accounts_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final accountsDatasourceProvider = Provider<AccountsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AccountsRemoteDatasourceImpl(dio: dio);
});

class AccountsNotifier extends StateNotifier<AsyncValue<List<AccountEntity>>> {
  final AccountsRemoteDatasource datasource;

  AccountsNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    state = const AsyncValue.loading();
    try {
      final accounts = await datasource.getAccounts();
      state = AsyncValue.data(accounts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addAccount(Map<String, dynamic> data) async {
    try {
      await datasource.createAccount(data);
      await fetchAccounts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      await datasource.deleteAccount(id);
      await fetchAccounts();
    } catch (e) {
      rethrow;
    }
  }
}

final accountsNotifierProvider =
    StateNotifierProvider<AccountsNotifier, AsyncValue<List<AccountEntity>>>((ref) {
  final datasource = ref.watch(accountsDatasourceProvider);
  return AccountsNotifier(datasource: datasource);
});

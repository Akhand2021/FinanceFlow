import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../data/datasources/transactions_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final transactionsDatasourceProvider = Provider<TransactionsRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TransactionsRemoteDatasourceImpl(dio: dio);
});

class TransactionsNotifier extends StateNotifier<AsyncValue<List<TransactionEntity>>> {
  final TransactionsRemoteDatasource datasource;

  TransactionsNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchTransactions();
  }

  Future<void> fetchTransactions({
    String? type,
    String? accountId,
    String? categoryId,
    String? search,
  }) async {
    state = const AsyncValue.loading();
    try {
      final transactions = await datasource.getTransactions(
        type: type,
        accountId: accountId,
        categoryId: categoryId,
        search: search,
      );
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    try {
      await datasource.createTransaction(data);
      await fetchTransactions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await datasource.deleteTransaction(id);
      await fetchTransactions();
    } catch (e) {
      rethrow;
    }
  }
}

final transactionsNotifierProvider =
    StateNotifierProvider<TransactionsNotifier, AsyncValue<List<TransactionEntity>>>((ref) {
  final datasource = ref.watch(transactionsDatasourceProvider);
  return TransactionsNotifier(datasource: datasource);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_entity.dart';
import '../../data/datasources/loans_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final loansDatasourceProvider = Provider<LoansRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return LoansRemoteDatasourceImpl(dio: dio);
});

class LoansNotifier extends StateNotifier<AsyncValue<List<LoanEntity>>> {
  final LoansRemoteDatasource datasource;

  LoansNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchLoans();
  }

  Future<void> fetchLoans() async {
    state = const AsyncValue.loading();
    try {
      final loans = await datasource.getLoans();
      state = AsyncValue.data(loans);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createLoan(Map<String, dynamic> data) async {
    try {
      await datasource.createLoan(data);
      await fetchLoans();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> recordPayment(String id, Map<String, dynamic> data) async {
    try {
      await datasource.recordPayment(id, data);
      await fetchLoans();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLoan(String id) async {
    try {
      await datasource.deleteLoan(id);
      await fetchLoans();
    } catch (e) {
      rethrow;
    }
  }
}

final loansNotifierProvider =
    StateNotifierProvider<LoansNotifier, AsyncValue<List<LoanEntity>>>((ref) {
  final datasource = ref.watch(loansDatasourceProvider);
  return LoansNotifier(datasource: datasource);
});

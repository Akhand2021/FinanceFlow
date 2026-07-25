import 'package:dio/dio.dart';
import '../models/transaction_model.dart';

abstract class TransactionsRemoteDatasource {
  Future<List<TransactionModel>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? accountId,
    String? categoryId,
    String? search,
  });
  Future<TransactionModel> getTransactionById(String id);
  Future<TransactionModel> createTransaction(Map<String, dynamic> data);
  Future<TransactionModel> updateTransaction(String id, Map<String, dynamic> data);
  Future<void> deleteTransaction(String id);
}

class TransactionsRemoteDatasourceImpl implements TransactionsRemoteDatasource {
  final Dio dio;

  TransactionsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<TransactionModel>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? accountId,
    String? categoryId,
    String? search,
  }) async {
    final response = await dio.get(
      '/transactions',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
        if (accountId != null) 'accountId': accountId,
        if (categoryId != null) 'categoryId': categoryId,
        if (search != null) 'search': search,
      },
    );
    final List list = response.data['data'];
    return list.map((json) => TransactionModel.fromJson(json)).toList();
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    final response = await dio.get('/transactions/$id');
    return TransactionModel.fromJson(response.data['data']);
  }

  @override
  Future<TransactionModel> createTransaction(Map<String, dynamic> data) async {
    final response = await dio.post('/transactions', data: data);
    return TransactionModel.fromJson(response.data['data']);
  }

  @override
  Future<TransactionModel> updateTransaction(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/transactions/$id', data: data);
    return TransactionModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await dio.delete('/transactions/$id');
  }
}

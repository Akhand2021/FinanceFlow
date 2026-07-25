import 'package:dio/dio.dart';
import '../models/account_model.dart';

abstract class AccountsRemoteDatasource {
  Future<List<AccountModel>> getAccounts();
  Future<AccountModel> getAccountById(String id);
  Future<AccountModel> createAccount(Map<String, dynamic> data);
  Future<AccountModel> updateAccount(String id, Map<String, dynamic> data);
  Future<void> deleteAccount(String id);
}

class AccountsRemoteDatasourceImpl implements AccountsRemoteDatasource {
  final Dio dio;

  AccountsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<AccountModel>> getAccounts() async {
    final response = await dio.get('/accounts');
    final List list = response.data['data'];
    return list.map((json) => AccountModel.fromJson(json)).toList();
  }

  @override
  Future<AccountModel> getAccountById(String id) async {
    final response = await dio.get('/accounts/$id');
    return AccountModel.fromJson(response.data['data']);
  }

  @override
  Future<AccountModel> createAccount(Map<String, dynamic> data) async {
    final response = await dio.post('/accounts', data: data);
    return AccountModel.fromJson(response.data['data']);
  }

  @override
  Future<AccountModel> updateAccount(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/accounts/$id', data: data);
    return AccountModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await dio.delete('/accounts/$id');
  }
}

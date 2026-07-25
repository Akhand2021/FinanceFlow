import 'package:dio/dio.dart';
import '../models/loan_model.dart';

abstract class LoansRemoteDatasource {
  Future<List<LoanModel>> getLoans();
  Future<LoanModel> getLoanById(String id);
  Future<LoanModel> createLoan(Map<String, dynamic> data);
  Future<LoanModel> recordPayment(String id, Map<String, dynamic> data);
  Future<LoanModel> updateLoan(String id, Map<String, dynamic> data);
  Future<void> deleteLoan(String id);
}

class LoansRemoteDatasourceImpl implements LoansRemoteDatasource {
  final Dio dio;

  LoansRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<LoanModel>> getLoans() async {
    final response = await dio.get('/loans');
    final List list = response.data['data'];
    return list.map((json) => LoanModel.fromJson(json)).toList();
  }

  @override
  Future<LoanModel> getLoanById(String id) async {
    final response = await dio.get('/loans/$id');
    return LoanModel.fromJson(response.data['data']);
  }

  @override
  Future<LoanModel> createLoan(Map<String, dynamic> data) async {
    final response = await dio.post('/loans', data: data);
    return LoanModel.fromJson(response.data['data']);
  }

  @override
  Future<LoanModel> recordPayment(String id, Map<String, dynamic> data) async {
    final response = await dio.post('/loans/$id/payment', data: data);
    return LoanModel.fromJson(response.data['data']);
  }

  @override
  Future<LoanModel> updateLoan(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/loans/$id', data: data);
    return LoanModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteLoan(String id) async {
    await dio.delete('/loans/$id');
  }
}

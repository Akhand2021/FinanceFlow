import 'package:dio/dio.dart';
import '../models/budget_model.dart';

abstract class BudgetsRemoteDatasource {
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel?> getCurrentBudget();
  Future<BudgetModel> getBudgetById(String id);
  Future<BudgetModel> createBudget(Map<String, dynamic> data);
  Future<BudgetModel> updateBudget(String id, Map<String, dynamic> data);
  Future<void> deleteBudget(String id);
}

class BudgetsRemoteDatasourceImpl implements BudgetsRemoteDatasource {
  final Dio dio;

  BudgetsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final response = await dio.get('/budgets');
    final List list = response.data['data'];
    return list.map((json) => BudgetModel.fromJson(json)).toList();
  }

  @override
  Future<BudgetModel?> getCurrentBudget() async {
    final response = await dio.get('/budgets/current');
    if (response.data['data'] == null) return null;
    return BudgetModel.fromJson(response.data['data']);
  }

  @override
  Future<BudgetModel> getBudgetById(String id) async {
    final response = await dio.get('/budgets/$id');
    return BudgetModel.fromJson(response.data['data']);
  }

  @override
  Future<BudgetModel> createBudget(Map<String, dynamic> data) async {
    final response = await dio.post('/budgets', data: data);
    return BudgetModel.fromJson(response.data['data']);
  }

  @override
  Future<BudgetModel> updateBudget(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/budgets/$id', data: data);
    return BudgetModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await dio.delete('/budgets/$id');
  }
}

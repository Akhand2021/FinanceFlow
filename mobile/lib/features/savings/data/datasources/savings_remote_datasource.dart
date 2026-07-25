import 'package:dio/dio.dart';
import '../models/saving_goal_model.dart';

abstract class SavingsRemoteDatasource {
  Future<List<SavingGoalModel>> getGoals();
  Future<SavingGoalModel> getGoalById(String id);
  Future<SavingGoalModel> createGoal(Map<String, dynamic> data);
  Future<SavingGoalModel> addContribution(String id, Map<String, dynamic> data);
  Future<SavingGoalModel> updateGoal(String id, Map<String, dynamic> data);
  Future<void> deleteGoal(String id);
}

class SavingsRemoteDatasourceImpl implements SavingsRemoteDatasource {
  final Dio dio;

  SavingsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<SavingGoalModel>> getGoals() async {
    final response = await dio.get('/savings');
    final List list = response.data['data'];
    return list.map((json) => SavingGoalModel.fromJson(json)).toList();
  }

  @override
  Future<SavingGoalModel> getGoalById(String id) async {
    final response = await dio.get('/savings/$id');
    return SavingGoalModel.fromJson(response.data['data']);
  }

  @override
  Future<SavingGoalModel> createGoal(Map<String, dynamic> data) async {
    final response = await dio.post('/savings', data: data);
    return SavingGoalModel.fromJson(response.data['data']);
  }

  @override
  Future<SavingGoalModel> addContribution(String id, Map<String, dynamic> data) async {
    final response = await dio.post('/savings/$id/contribute', data: data);
    return SavingGoalModel.fromJson(response.data['data']);
  }

  @override
  Future<SavingGoalModel> updateGoal(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/savings/$id', data: data);
    return SavingGoalModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteGoal(String id) async {
    await dio.delete('/savings/$id');
  }
}

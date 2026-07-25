import 'package:dio/dio.dart';
import '../models/financial_health_score_model.dart';

abstract class ReportsRemoteDatasource {
  Future<Map<String, dynamic>> getSummary({String? startDate, String? endDate});
  Future<FinancialHealthScoreModel> getHealthScore();
}

class ReportsRemoteDatasourceImpl implements ReportsRemoteDatasource {
  final Dio dio;

  ReportsRemoteDatasourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getSummary({String? startDate, String? endDate}) async {
    final response = await dio.get('/reports/summary', queryParameters: {
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    });
    return response.data['data'];
  }

  @override
  Future<FinancialHealthScoreModel> getHealthScore() async {
    final response = await dio.get('/reports/health-score');
    return FinancialHealthScoreModel.fromJson(response.data['data']);
  }
}

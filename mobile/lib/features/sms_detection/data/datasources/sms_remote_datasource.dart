import 'package:dio/dio.dart';
import '../models/sms_pending_model.dart';

abstract class SmsRemoteDatasource {
  Future<List<SmsPendingModel>> getPendingSms();
  Future<SmsPendingModel> ingestSms(Map<String, dynamic> data);
  Future<SmsPendingModel> processSms(String id, String action, {String? accountId, String? categoryId});
}

class SmsRemoteDatasourceImpl implements SmsRemoteDatasource {
  final Dio dio;

  SmsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<SmsPendingModel>> getPendingSms() async {
    final response = await dio.get('/sms-pending');
    final List list = response.data['data'];
    return list.map((json) => SmsPendingModel.fromJson(json)).toList();
  }

  @override
  Future<SmsPendingModel> ingestSms(Map<String, dynamic> data) async {
    final response = await dio.post('/sms-pending/ingest', data: data);
    return SmsPendingModel.fromJson(response.data['data']);
  }

  @override
  Future<SmsPendingModel> processSms(String id, String action, {String? accountId, String? categoryId}) async {
    final response = await dio.post('/sms-pending/$id/process', data: {
      'action': action,
      if (accountId != null) 'accountId': accountId,
      if (categoryId != null) 'categoryId': categoryId,
    });
    return SmsPendingModel.fromJson(response.data['data']);
  }
}

import 'package:dio/dio.dart';
import '../models/user_settings_model.dart';

abstract class SettingsRemoteDatasource {
  Future<UserSettingsModel> getSettings();
  Future<UserSettingsModel> updateSettings(Map<String, dynamic> data);
  Future<Map<String, dynamic>> exportData();
  Future<void> deleteAccount();
}

class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  final Dio dio;

  SettingsRemoteDatasourceImpl({required this.dio});

  @override
  Future<UserSettingsModel> getSettings() async {
    final response = await dio.get('/users/settings');
    return UserSettingsModel.fromJson(response.data['data']);
  }

  @override
  Future<UserSettingsModel> updateSettings(Map<String, dynamic> data) async {
    final response = await dio.put('/users/settings', data: data);
    return UserSettingsModel.fromJson(response.data['data']);
  }

  @override
  Future<Map<String, dynamic>> exportData() async {
    final response = await dio.get('/users/export');
    return response.data['data'];
  }

  @override
  Future<void> deleteAccount() async {
    await dio.delete('/users/account');
  }
}

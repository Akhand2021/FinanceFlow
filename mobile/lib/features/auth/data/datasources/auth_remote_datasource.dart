import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDatasource {
  Future<(UserModel, AuthTokensModel)> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  });

  Future<(UserModel, AuthTokensModel)> login({
    required String email,
    required String password,
  });

  Future<AuthTokensModel> refreshToken({required String refreshToken});

  Future<void> logout({required String userId});

  Future<UserModel> getCurrentUser();

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<(UserModel, AuthTokensModel)> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      final data = response.data['data'];
      final user = UserModel.fromJson(data);
      final tokens = AuthTokensModel.fromJson(data['tokens']);

      return (user, tokens);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(UserModel, AuthTokensModel)> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'];
      final user = UserModel.fromJson(data);
      final tokens = AuthTokensModel.fromJson(data['tokens']);

      return (user, tokens);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthTokensModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final tokens = AuthTokensModel.fromJson(response.data['data']);
      return tokens;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout({required String userId}) async {
    try {
      await dio.post('/auth/logout');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');
      final user = UserModel.fromJson(response.data['data']);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await dio.post('/auth/forgot-password', data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}

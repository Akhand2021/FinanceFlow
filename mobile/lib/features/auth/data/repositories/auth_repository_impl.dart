import 'package:dartz/dartz.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  Exception _wrapException(dynamic error) {
    if (error is Exception) return error;
    return Exception(error.toString());
  }

  @override
  Future<Either<Exception, (UserEntity, AuthTokensEntity)>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final (userModel, tokensModel) = await remoteDatasource.register(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        confirmPassword: confirmPassword,
      );

      await localDatasource.saveUser(userModel);
      await localDatasource.saveTokens(tokensModel);

      return Right((userModel.toEntity(), tokensModel.toEntity()));
    } catch (e) {
      return Left(_wrapException(e));
    }
  }

  @override
  Future<Either<Exception, (UserEntity, AuthTokensEntity)>> login({
    required String email,
    required String password,
  }) async {
    try {
      final (userModel, tokensModel) = await remoteDatasource.login(
        email: email,
        password: password,
      );

      await localDatasource.saveUser(userModel);
      await localDatasource.saveTokens(tokensModel);

      return Right((userModel.toEntity(), tokensModel.toEntity()));
    } catch (e) {
      return Left(_wrapException(e));
    }
  }

  @override
  Future<Either<Exception, AuthTokensEntity>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final tokensModel = await remoteDatasource.refreshToken(
        refreshToken: refreshToken,
      );
      await localDatasource.saveTokens(tokensModel);

      return Right(tokensModel.toEntity());
    } catch (e) {
      return Left(_wrapException(e));
    }
  }

  @override
  Future<Either<Exception, void>> logout({required String userId}) async {
    try {
      await remoteDatasource.logout(userId: userId);
      await localDatasource.clearAll();

      return const Right(null);
    } catch (e) {
      return Left(_wrapException(e));
    }
  }

  @override
  Future<Either<Exception, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDatasource.getCurrentUser();
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(_wrapException(e));
    }
  }

  @override
  Future<Either<Exception, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await remoteDatasource.forgotPassword(email: email);
      return const Right(null);
    } catch (e) {
      return Left(_wrapException(e));
    }
  }

  @override
  Future<Either<Exception, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDatasource.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(_wrapException(e));
    }
  }
}

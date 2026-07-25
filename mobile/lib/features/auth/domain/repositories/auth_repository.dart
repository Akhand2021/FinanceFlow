import 'package:dartz/dartz.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_tokens_entity.dart';

abstract class AuthRepository {
  Future<Either<Exception, (UserEntity, AuthTokensEntity)>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Exception, (UserEntity, AuthTokensEntity)>> login({
    required String email,
    required String password,
  });

  Future<Either<Exception, AuthTokensEntity>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Exception, void>> logout({required String userId});

  Future<Either<Exception, UserEntity>> getCurrentUser();

  Future<Either<Exception, void>> forgotPassword({required String email});

  Future<Either<Exception, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
}

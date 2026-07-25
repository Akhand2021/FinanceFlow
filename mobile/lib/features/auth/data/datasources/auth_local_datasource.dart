import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';
import '../../../../core/services/local_storage_service.dart';

abstract class AuthLocalDatasource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getTokens();
  Future<void> clearAll();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final LocalStorageService localStorageService;

  AuthLocalDatasourceImpl({required this.localStorageService});

  @override
  Future<void> saveUser(UserModel user) async {
    await localStorageService.saveUserId(user.id);
    await localStorageService.saveUserEmail(user.email);
  }

  @override
  Future<UserModel?> getUser() async {
    final userId = await localStorageService.getUserId();
    final email = await localStorageService.getUserEmail();

    if (userId == null || email == null) {
      return null;
    }

    return UserModel(
      id: userId,
      email: email,
      firstName: '',
      lastName: '',
      currency: 'USD',
      language: 'en',
      theme: 'light',
      pinnedLocked: false,
      biometricLocked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await localStorageService.saveAccessToken(tokens.accessToken);
    await localStorageService.saveRefreshToken(tokens.refreshToken);
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    final accessToken = await localStorageService.getAccessToken();
    final refreshToken = await localStorageService.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return AuthTokensModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: 86400,
      tokenType: 'Bearer',
    );
  }

  @override
  Future<void> clearAll() async {
    await localStorageService.clearAll();
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';

  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _preferences;

  LocalStorageService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _prefs async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // Access Token
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(key: accessTokenKey, value: token);
    } catch (e) {
      final prefs = await _prefs;
      await prefs.setString(accessTokenKey, token);
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = await _secureStorage.read(key: accessTokenKey);
      if (token != null) return token;
    } catch (_) {}

    final prefs = await _prefs;
    return prefs.getString(accessTokenKey);
  }

  Future<void> clearAccessToken() async {
    try {
      await _secureStorage.delete(key: accessTokenKey);
    } catch (_) {}

    final prefs = await _prefs;
    await prefs.remove(accessTokenKey);
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: refreshTokenKey, value: token);
    } catch (e) {
      final prefs = await _prefs;
      await prefs.setString(refreshTokenKey, token);
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final token = await _secureStorage.read(key: refreshTokenKey);
      if (token != null) return token;
    } catch (_) {}

    final prefs = await _prefs;
    return prefs.getString(refreshTokenKey);
  }

  Future<void> clearRefreshToken() async {
    try {
      await _secureStorage.delete(key: refreshTokenKey);
    } catch (_) {}

    final prefs = await _prefs;
    await prefs.remove(refreshTokenKey);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    final prefs = await _prefs;
    await prefs.setString(userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(userIdKey);
  }

  // User Email
  Future<void> saveUserEmail(String email) async {
    final prefs = await _prefs;
    await prefs.setString(userEmailKey, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString(userEmailKey);
  }

  // Clear all
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (_) {}

    final prefs = await _prefs;
    await prefs.clear();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

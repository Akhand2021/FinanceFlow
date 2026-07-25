import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/local_storage_service.dart';
import 'auth_state.dart';
import '../../../../core/providers/providers.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final LocalStorageService localStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.localStorageService,
  }) : super(initialAuthState);

  // Register
  Future<void> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authRepository.register(
      email: email,
      firstName: firstName,
      lastName: lastName,
      password: password,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (exception) {
        state = state.copyWith(
          isLoading: false,
          error: exception.toString(),
        );
      },
      (tuple) {
        state = state.copyWith(
          isAuthenticated: true,
          user: tuple.$1,
          tokens: tuple.$2,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (exception) {
        state = state.copyWith(
          isLoading: false,
          error: exception.toString(),
        );
      },
      (tuple) {
        state = state.copyWith(
          isAuthenticated: true,
          user: tuple.$1,
          tokens: tuple.$2,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    final userId = state.user?.id;
    if (userId == null) {
      state = initialAuthState;
      return;
    }

    final result = await authRepository.logout(userId: userId);

    result.fold(
      (exception) {
        state = state.copyWith(
          isLoading: false,
          error: exception.toString(),
        );
      },
      (_) {
        state = initialAuthState;
      },
    );
  }

  // Refresh Token
  Future<void> refreshAccessToken() async {
    final refreshToken = state.tokens?.refreshToken;
    if (refreshToken == null) {
      state = state.copyWith(error: 'No refresh token available');
      return;
    }

    final result = await authRepository.refreshToken(
      refreshToken: refreshToken,
    );

    result.fold(
      (exception) {
        state = state.copyWith(
          isAuthenticated: false,
          error: exception.toString(),
        );
      },
      (tokens) {
        state = state.copyWith(
          tokens: tokens,
          error: null,
        );
      },
    );
  }

  // Get Current User
  Future<void> getCurrentUser() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authRepository.getCurrentUser();

    result.fold(
      (exception) {
        state = state.copyWith(
          isLoading: false,
          error: exception.toString(),
        );
      },
      (user) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  // Forgot Password
  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authRepository.forgotPassword(email: email);

    result.fold(
      (exception) {
        state = state.copyWith(
          isLoading: false,
          error: exception.toString(),
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      },
    );
  }

  // Reset Password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authRepository.resetPassword(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (exception) {
        state = state.copyWith(
          isLoading: false,
          error: exception.toString(),
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      },
    );
  }

  // Clear Error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final localStorageService = ref.watch(localStorageServiceProvider);

    return AuthNotifier(
      authRepository: authRepository,
      localStorageService: localStorageService,
    );
  },
);

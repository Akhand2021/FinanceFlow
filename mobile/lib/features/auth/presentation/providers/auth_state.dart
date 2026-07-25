import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_tokens_entity.dart';

// Auth State
class AuthState {
  final bool isAuthenticated;
  final UserEntity? user;
  final AuthTokensEntity? tokens;
  final bool isLoading;
  final String? error;

  AuthState({
    required this.isAuthenticated,
    this.user,
    this.tokens,
    required this.isLoading,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserEntity? user,
    AuthTokensEntity? tokens,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  String toString() =>
      'AuthState(isAuthenticated: $isAuthenticated, user: $user, isLoading: $isLoading, error: $error)';
}

// Initial state
final initialAuthState = AuthState(
  isAuthenticated: false,
  user: null,
  tokens: null,
  isLoading: false,
  error: null,
);

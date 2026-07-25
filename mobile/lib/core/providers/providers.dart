import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/local_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

// Services
final localStorageServiceProvider = Provider((ref) {
  return LocalStorageService();
});

// Datasources
final authRemoteDatasourceProvider = Provider((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRemoteDatasourceImpl(dio: dio);
});

final authLocalDatasourceProvider = Provider((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return AuthLocalDatasourceImpl(localStorageService: localStorage);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);

  return AuthRepositoryImpl(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
  );
});

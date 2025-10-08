import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:recurseo/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:recurseo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:recurseo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:recurseo/features/auth/domain/repositories/auth_repository.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider de SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider del local datasource
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return AuthLocalDataSource(prefs);
});

/// Provider del mock datasource
final authMockDataSourceProvider = Provider<AuthMockDataSource>((ref) {
  return AuthMockDataSource();
});

/// Provider del remote datasource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio);
});

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(authLocalDataSourceProvider);

  if (AppConfig.useMockData) {
    final mockDataSource = ref.watch(authMockDataSourceProvider);
    return AuthRepositoryImpl(
      mockDataSource: mockDataSource,
      localDataSource: localDataSource,
    );
  } else {
    final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
    return AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }
});

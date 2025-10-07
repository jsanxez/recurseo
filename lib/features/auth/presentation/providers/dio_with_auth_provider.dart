import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/features/auth/data/datasources/auth_interceptor.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_providers.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider de Dio configurado con autenticación
/// Este provider resuelve el ciclo de dependencias agregando el interceptor
/// después de que los otros providers estén listos
final dioWithAuthProvider = Provider<Dio>((ref) {
  final dio = ref.watch(dioProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  // Agregar interceptor de autenticación
  final authInterceptor = AuthInterceptor(
    localDataSource: authLocalDataSource,
    authRepository: authRepository,
    dio: dio,
  );

  // Verificar si ya está agregado para no duplicar
  final hasAuthInterceptor = dio.interceptors.any(
    (interceptor) => interceptor is AuthInterceptor,
  );

  if (!hasAuthInterceptor) {
    dio.interceptors.add(authInterceptor);
  }

  return dio;
});

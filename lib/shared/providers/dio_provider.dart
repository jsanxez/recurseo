import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/api_config.dart';

/// Provider de Dio configurado para la aplicación
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.defaultHeaders,
    ),
  );

  // Interceptor para logging (solo en debug)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
    ),
  );

  // Nota: El interceptor de autenticación se configura en auth_interceptor.dart
  // para evitar dependencias circulares

  return dio;
});

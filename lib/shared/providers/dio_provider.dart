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

  // Interceptor para autenticación
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TODO: Agregar token de autenticación
        // final token = await ref.read(authTokenProvider.future);
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Manejo de errores de autenticación
        if (error.response?.statusCode == 401) {
          // TODO: Refrescar token o redirigir a login
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});

import 'package:dio/dio.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:recurseo/features/auth/domain/repositories/auth_repository.dart';

/// Interceptor para agregar automáticamente el token de autenticación
class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;
  final AuthRepository _authRepository;
  final Dio _dio;
  final _logger = const Logger('AuthInterceptor');

  AuthInterceptor({
    required AuthLocalDataSource localDataSource,
    required AuthRepository authRepository,
    required Dio dio,
  })  : _localDataSource = localDataSource,
        _authRepository = authRepository,
        _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Agregar token de autenticación si existe
    final token = _localDataSource.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      _logger.debug('Token agregado a la request');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Manejo de token expirado (401)
    if (err.response?.statusCode == 401) {
      _logger.warning('Token expirado, intentando refresh...');

      try {
        // Intentar refrescar el token
        final result = await _authRepository.refreshToken();

        if (result is Success) {
          _logger.success('Token refreshed exitosamente');

          // Reintentar la request original con el nuevo token
          final newToken = _localDataSource.getAccessToken();

          if (newToken != null) {
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            // Reintentar la request
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        } else {
          _logger.error('Refresh token falló');
        }
      } catch (e) {
        _logger.error('Error al refrescar token', e);
      }
    }

    // Si no es 401 o falla el refresh, continuar con el error
    handler.next(err);
  }
}

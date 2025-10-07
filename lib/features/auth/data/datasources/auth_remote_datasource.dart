import 'package:dio/dio.dart';
import 'package:recurseo/core/config/api_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/auth/data/models/auth_response_model.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';

/// DataSource remoto para llamadas a la API de autenticación
class AuthRemoteDataSource {
  final Dio _dio;
  final _logger = const Logger('AuthRemoteDataSource');

  AuthRemoteDataSource(this._dio);

  /// Login con email y contraseña
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting login for: $email');

      final response = await _dio.post(
        '${ApiConfig.auth}/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      _logger.success('Login successful');
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Login failed', e);
      throw _handleDioError(e);
    }
  }

  /// Registro de nuevo usuario
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
  }) async {
    try {
      _logger.info('Attempting registration for: $email');

      final response = await _dio.post(
        '${ApiConfig.auth}/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'user_type': userType == UserType.client ? 'client' : 'provider',
          'phone_number': phoneNumber,
        },
      );

      _logger.success('Registration successful');
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Registration failed', e);
      throw _handleDioError(e);
    }
  }

  /// Refrescar token de acceso
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      _logger.info('Refreshing access token');

      final response = await _dio.post(
        '${ApiConfig.auth}/refresh',
        data: {'refresh_token': refreshToken},
      );

      _logger.success('Token refreshed successfully');
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Token refresh failed', e);
      throw _handleDioError(e);
    }
  }

  /// Logout (invalidar token en servidor)
  Future<void> logout(String accessToken) async {
    try {
      _logger.info('Logging out');

      await _dio.post(
        '${ApiConfig.auth}/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      _logger.success('Logout successful');
    } on DioException catch (e) {
      _logger.warning('Logout failed, but continuing: ${e.message}');
      // No lanzamos error, solo logueamos
    }
  }

  /// Solicitar reset de contraseña
  Future<void> resetPassword(String email) async {
    try {
      _logger.info('Requesting password reset for: $email');

      await _dio.post(
        '${ApiConfig.auth}/reset-password',
        data: {'email': email},
      );

      _logger.success('Password reset email sent');
    } on DioException catch (e) {
      _logger.error('Password reset failed', e);
      throw _handleDioError(e);
    }
  }

  /// Manejar errores de Dio
  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data['message'] as String?;

    return switch (statusCode) {
      400 => Exception(message ?? 'Datos inválidos'),
      401 => Exception(message ?? 'Credenciales incorrectas'),
      403 => Exception(message ?? 'Acceso denegado'),
      404 => Exception(message ?? 'Usuario no encontrado'),
      409 => Exception(message ?? 'El email ya está registrado'),
      500 => Exception('Error del servidor. Intenta más tarde'),
      _ => Exception(message ?? 'Error de conexión'),
    };
  }
}

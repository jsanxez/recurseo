import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:recurseo/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:recurseo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:recurseo/features/auth/data/models/user_model.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/domain/repositories/auth_repository.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource? _remoteDataSource;
  final AuthMockDataSource? _mockDataSource;
  final AuthLocalDataSource _localDataSource;
  final _logger = const Logger('AuthRepositoryImpl');

  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
    AuthMockDataSource? mockDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _mockDataSource = mockDataSource,
        _localDataSource = localDataSource {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for authentication');
    } else {
      _logger.info('🌐 Using REMOTE API for authentication');
    }
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> response;

      if (AppConfig.useMockData) {
        // Usar mock datasource
        response = await _mockDataSource!.login(
          email: email,
          password: password,
        );
      } else {
        // Usar API remota
        final apiResponse = await _remoteDataSource!.login(
          email: email,
          password: password,
        );
        response = {
          'user': apiResponse.user.toJson(),
          'access_token': apiResponse.accessToken,
          'refresh_token': apiResponse.refreshToken,
          'expires_at': apiResponse.expiresAt.toIso8601String(),
        };
      }

      // Parse response
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;
      final expiresAt = DateTime.parse(response['expires_at'] as String);

      // Guardar datos localmente
      await _localDataSource.saveAuthData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        expiresAt: expiresAt,
      );

      _logger.success('Login completed successfully');
      return Success(user);
    } catch (e, st) {
      _logger.error('Login failed', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
  }) async {
    try {
      final Map<String, dynamic> response;

      if (AppConfig.useMockData) {
        // Usar mock datasource
        response = await _mockDataSource!.register(
          email: email,
          password: password,
          name: name,
          userType: userType,
          phoneNumber: phoneNumber,
        );
      } else {
        // Usar API remota
        final apiResponse = await _remoteDataSource!.register(
          email: email,
          password: password,
          name: name,
          userType: userType,
          phoneNumber: phoneNumber,
        );
        response = {
          'user': apiResponse.user.toJson(),
          'access_token': apiResponse.accessToken,
          'refresh_token': apiResponse.refreshToken,
          'expires_at': apiResponse.expiresAt.toIso8601String(),
        };
      }

      // Parse response
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;
      final expiresAt = DateTime.parse(response['expires_at'] as String);

      // Guardar datos localmente
      await _localDataSource.saveAuthData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        expiresAt: expiresAt,
      );

      _logger.success('Registration completed successfully');
      return Success(user);
    } catch (e, st) {
      _logger.error('Registration failed', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Intentar invalidar token en servidor
      final accessToken = _localDataSource.getAccessToken();
      if (accessToken != null) {
        if (AppConfig.useMockData) {
          await _mockDataSource!.logout();
        } else {
          await _remoteDataSource!.logout(accessToken);
        }
      }

      // Limpiar datos locales
      await _localDataSource.clearAuthData();

      _logger.success('Logout completed successfully');
      return const Success(null);
    } catch (e, st) {
      _logger.error('Logout failed', e, st);

      // Aunque falle el servidor, limpiamos localmente
      await _localDataSource.clearAuthData();

      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final user = _localDataSource.getUser();
      return Success(user);
    } catch (e, st) {
      _logger.error('Error getting current user', e, st);
      return Failure(
        message: 'Error al obtener usuario actual',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _localDataSource.hasActiveSession();
  }

  @override
  Future<Result<void>> refreshToken() async {
    try {
      final refreshToken = _localDataSource.getRefreshToken();

      if (refreshToken == null) {
        return const Failure(message: 'No refresh token available');
      }

      final Map<String, dynamic> response;

      if (AppConfig.useMockData) {
        // Usar mock datasource
        response = await _mockDataSource!.refreshToken(refreshToken);

        // Parse mock response
        final accessToken = response['access_token'] as String;
        final newRefreshToken = response['refresh_token'] as String;
        final expiresAt = DateTime.parse(response['expires_at'] as String);
        final user = _localDataSource.getUser();

        // Guardar nuevos tokens
        await _localDataSource.saveAuthData(
          accessToken: accessToken,
          refreshToken: newRefreshToken,
          user: user!,
          expiresAt: expiresAt,
        );
      } else {
        // Llamar a la API para refrescar
        final apiResponse = await _remoteDataSource!.refreshToken(refreshToken);

        // Guardar nuevos tokens
        await _localDataSource.saveAuthData(
          accessToken: apiResponse.accessToken,
          refreshToken: apiResponse.refreshToken,
          user: apiResponse.user,
          expiresAt: apiResponse.expiresAt,
        );
      }

      _logger.success('Token refreshed successfully');
      return const Success(null);
    } catch (e, st) {
      _logger.error('Token refresh failed', e, st);

      // Si falla el refresh, limpiar sesión
      await _localDataSource.clearAuthData();

      return Failure(
        message: 'Sesión expirada. Inicia sesión nuevamente',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.resetPassword(email);
      } else {
        await _remoteDataSource!.resetPassword(email);
      }
      _logger.success('Password reset email sent');
      return const Success(null);
    } catch (e, st) {
      _logger.error('Password reset failed', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }
}

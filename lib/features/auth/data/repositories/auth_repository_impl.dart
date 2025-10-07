import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:recurseo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/domain/repositories/auth_repository.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final _logger = const Logger('AuthRepositoryImpl');

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Llamar a la API
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Guardar datos localmente
      await _localDataSource.saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response.user,
        expiresAt: response.expiresAt,
      );

      _logger.success('Login completed successfully');
      return Success(response.user);
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
      // Llamar a la API
      final response = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        userType: userType,
        phoneNumber: phoneNumber,
      );

      // Guardar datos localmente
      await _localDataSource.saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response.user,
        expiresAt: response.expiresAt,
      );

      _logger.success('Registration completed successfully');
      return Success(response.user);
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
        await _remoteDataSource.logout(accessToken);
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

      // Llamar a la API para refrescar
      final response = await _remoteDataSource.refreshToken(refreshToken);

      // Guardar nuevos tokens
      await _localDataSource.saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response.user,
        expiresAt: response.expiresAt,
      );

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
      await _remoteDataSource.resetPassword(email);
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

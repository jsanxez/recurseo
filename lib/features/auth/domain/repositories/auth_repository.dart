import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';

/// Contrato del repositorio de autenticación
abstract class AuthRepository {
  /// Login con email y contraseña
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  /// Registro de nuevo usuario
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
  });

  /// Cerrar sesión
  Future<Result<void>> logout();

  /// Obtener usuario actual (desde cache/storage)
  Future<Result<UserEntity?>> getCurrentUser();

  /// Verificar si hay sesión activa
  Future<bool> isAuthenticated();

  /// Refrescar token de acceso
  Future<Result<void>> refreshToken();

  /// Recuperar contraseña
  Future<Result<void>> resetPassword({required String email});
}

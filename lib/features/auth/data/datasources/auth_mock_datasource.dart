import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/auth/data/models/user_model.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';

/// DataSource mock para autenticación (datos de prueba)
class AuthMockDataSource {
  final _logger = const Logger('AuthMockDataSource');

  // Usuarios de prueba
  static final _mockUsers = <UserModel>[
    // Cliente
    UserModel(
      id: '1',
      email: 'cliente@test.com',
      name: 'Juan Pérez',
      userType: UserType.client,
      phoneNumber: '+593 99 123 4567',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    // Proveedor/Profesional
    UserModel(
      id: '2',
      email: 'profesional@test.com',
      name: 'María González',
      userType: UserType.provider,
      phoneNumber: '+593 98 765 4321',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    // Admin (cliente también)
    UserModel(
      id: '3',
      email: 'admin@test.com',
      name: 'Carlos Admin',
      userType: UserType.client,
      phoneNumber: '+593 99 888 7777',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  /// Login con email y contraseña
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    _logger.info('Mock login attempt for: $email');
    await Future.delayed(const Duration(milliseconds: 800));

    // Buscar usuario por email
    final user = _mockUsers.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('Usuario no encontrado'),
    );

    // En mock, cualquier contraseña es válida (solo para desarrollo)
    if (password.isEmpty) {
      throw Exception('Contraseña requerida');
    }

    _logger.success('Mock login successful for: $email');

    // Retornar datos de autenticación
    return {
      'user': user.toJson(),
      'access_token': 'mock_access_token_${user.id}',
      'refresh_token': 'mock_refresh_token_${user.id}',
      'expires_at': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String(),
    };
  }

  /// Registro de nuevo usuario
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
  }) async {
    _logger.info('Mock register attempt for: $email');
    await Future.delayed(const Duration(milliseconds: 1000));

    // Verificar si el email ya existe
    final exists = _mockUsers.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (exists) {
      throw Exception('El email ya está registrado');
    }

    // Crear nuevo usuario
    final newUser = UserModel(
      id: '${_mockUsers.length + 1}',
      email: email,
      name: name,
      userType: userType,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
    );

    _mockUsers.add(newUser);
    _logger.success('Mock register successful for: $email');

    // Retornar datos de autenticación
    return {
      'user': newUser.toJson(),
      'access_token': 'mock_access_token_${newUser.id}',
      'refresh_token': 'mock_refresh_token_${newUser.id}',
      'expires_at': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String(),
    };
  }

  /// Obtener usuario actual (verificar token)
  Future<UserModel> getCurrentUser(String accessToken) async {
    _logger.info('Mock: Getting current user');
    await Future.delayed(const Duration(milliseconds: 300));

    // Extraer ID del token mock
    final userId = accessToken.replaceAll('mock_access_token_', '');

    final user = _mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Token inválido'),
    );

    return user;
  }

  /// Refresh token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    _logger.info('Mock: Refreshing token');
    await Future.delayed(const Duration(milliseconds: 400));

    // Extraer ID del refresh token mock
    final userId = refreshToken.replaceAll('mock_refresh_token_', '');

    final user = _mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Refresh token inválido'),
    );

    return {
      'access_token': 'mock_access_token_${user.id}',
      'refresh_token': 'mock_refresh_token_${user.id}',
      'expires_at': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String(),
    };
  }

  /// Logout (no hace nada en mock, el borrado de datos es local)
  Future<void> logout() async {
    _logger.info('Mock: Logout');
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Reset password (simula envío de email)
  Future<void> resetPassword(String email) async {
    _logger.info('Mock: Sending password reset email to $email');
    await Future.delayed(const Duration(milliseconds: 600));

    // Verificar que el email existe
    final exists = _mockUsers.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (!exists) {
      throw Exception('No existe una cuenta con este email');
    }

    _logger.success('Mock: Password reset email sent to $email');
  }
}

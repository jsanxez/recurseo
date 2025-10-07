import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/auth/data/models/auth_response_model.dart';
import 'package:recurseo/features/auth/data/models/user_model.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';

/// DataSource mock para autenticación (datos de prueba)
class AuthMockDataSource {
  final _logger = const Logger('AuthMockDataSource');

  // Usuarios de prueba
  static final _mockUsers = [
    UserModel(
      id: '1',
      email: 'cliente@test.com',
      name: 'Juan Pérez',
      userType: UserType.client,
      phoneNumber: '+593 99 123 4567',
      photoUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: '2',
      email: 'proveedor@test.com',
      name: 'María González',
      userType: UserType.provider,
      phoneNumber: '+593 99 765 4321',
      photoUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    UserModel(
      id: '3',
      email: 'admin@test.com',
      name: 'Carlos Admin',
      userType: UserType.client,
      phoneNumber: '+593 99 555 5555',
      photoUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  /// Simular login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    _logger.info('Mock login attempt for: $email');

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Buscar usuario por email
    final user = _mockUsers.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Usuario no encontrado'),
    );

    // Simular que cualquier contraseña es válida para el mock
    if (password.isEmpty) {
      throw Exception('Contraseña requerida');
    }

    _logger.success('Mock login successful for: ${user.email}');

    return AuthResponseModel(
      accessToken: 'mock_access_token_${user.id}',
      refreshToken: 'mock_refresh_token_${user.id}',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      user: user,
    );
  }

  /// Simular registro
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phoneNumber,
  }) async {
    _logger.info('Mock register attempt for: $email');

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Verificar si el email ya existe
    final emailExists = _mockUsers.any((u) => u.email == email);
    if (emailExists) {
      throw Exception('El email ya está registrado');
    }

    // Crear nuevo usuario
    final newUser = UserModel(
      id: '${_mockUsers.length + 1}',
      email: email,
      name: name,
      userType: userType,
      phoneNumber: phoneNumber,
      photoUrl: null,
      createdAt: DateTime.now(),
    );

    // Agregar a la lista de usuarios mock
    _mockUsers.add(newUser);

    _logger.success('Mock register successful for: ${newUser.email}');

    return AuthResponseModel(
      accessToken: 'mock_access_token_${newUser.id}',
      refreshToken: 'mock_refresh_token_${newUser.id}',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      user: newUser,
    );
  }

  /// Simular obtener usuario actual
  Future<UserModel> getCurrentUser(String token) async {
    _logger.info('Mock getCurrentUser');

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    // Extraer ID del token (en mock, el token contiene el ID)
    final userId = token.replaceAll('mock_access_token_', '');

    final user = _mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Usuario no encontrado'),
    );

    return user;
  }

  /// Simular refresh token
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    _logger.info('Mock refreshToken');

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    // Extraer ID del refresh token
    final userId = refreshToken.replaceAll('mock_refresh_token_', '');

    final user = _mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Token inválido'),
    );

    return AuthResponseModel(
      accessToken: 'mock_access_token_${user.id}_refreshed',
      refreshToken: 'mock_refresh_token_${user.id}_refreshed',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      user: user,
    );
  }

  /// Simular logout
  Future<void> logout() async {
    _logger.info('Mock logout');
    await Future.delayed(const Duration(milliseconds: 300));
    // En mock, no hay nada que hacer en el servidor
  }

  /// Obtener lista de usuarios de prueba (para debugging)
  List<UserModel> getMockUsers() => List.unmodifiable(_mockUsers);
}

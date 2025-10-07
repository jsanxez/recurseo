import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/domain/repositories/auth_repository.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_providers.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';

/// Notifier para manejar el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final _logger = const Logger('AuthNotifier');

  AuthNotifier(this._authRepository) : super(const AuthInitial()) {
    // Verificar sesión al inicializar
    _checkAuthStatus();
  }

  /// Verificar si hay sesión activa
  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (isAuth) {
        final result = await _authRepository.getCurrentUser();

        result.whenSuccess((user) {
          if (user != null) {
            state = Authenticated(user);
            _logger.success('User session restored: ${user.email}');
          } else {
            state = const Unauthenticated();
          }
        });

        result.whenFailure((_) {
          state = const Unauthenticated();
        });
      } else {
        state = const Unauthenticated();
      }
    } catch (e, st) {
      _logger.error('Error checking auth status', e, st);
      state = const Unauthenticated();
    }
  }

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    switch (result) {
      case Success(data: final user):
        state = Authenticated(user);
        _logger.success('Login successful: ${user.email}');

      case Failure(message: final message):
        state = AuthError(message);
        _logger.error('Login failed: $message');
    }
  }

  /// Registro
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
  }) async {
    state = const AuthLoading();

    final result = await _authRepository.register(
      email: email,
      password: password,
      name: name,
      userType: userType,
      phoneNumber: phoneNumber,
    );

    switch (result) {
      case Success(data: final user):
        state = Authenticated(user);
        _logger.success('Registration successful: ${user.email}');

      case Failure(message: final message):
        state = AuthError(message);
        _logger.error('Registration failed: $message');
    }
  }

  /// Logout
  Future<void> logout() async {
    state = const AuthLoading();

    final result = await _authRepository.logout();

    switch (result) {
      case Success():
        state = const Unauthenticated();
        _logger.success('Logout successful');

      case Failure(message: final message):
        // Aunque falle, marcamos como no autenticado
        state = const Unauthenticated();
        _logger.warning('Logout completed with warning: $message');
    }
  }

  /// Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    final result = await _authRepository.resetPassword(email: email);

    return switch (result) {
      Success() => true,
      Failure() => false,
    };
  }

  /// Limpiar error
  void clearError() {
    if (state is AuthError) {
      state = const Unauthenticated();
    }
  }
}

/// Provider del AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

/// Helper provider para obtener el usuario actual
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return switch (authState) {
    Authenticated(user: final user) => user,
    _ => null,
  };
});

/// Helper provider para saber si está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is Authenticated;
});

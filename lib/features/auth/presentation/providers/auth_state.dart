import 'package:equatable/equatable.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';

/// Estado de autenticación
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial / sin determinar
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carga (login, registro, etc)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Usuario autenticado
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Usuario no autenticado
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Error de autenticación
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

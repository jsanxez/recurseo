import 'package:equatable/equatable.dart';

/// Tipo de usuario en la plataforma
enum UserType {
  client,
  provider,
}

/// Entidad de usuario (lógica de dominio pura)
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserType userType;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    this.phoneNumber,
    this.photoUrl,
    required this.createdAt,
  });

  /// Copia la entidad con nuevos valores
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    UserType? userType,
    String? phoneNumber,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      userType: userType ?? this.userType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        userType,
        phoneNumber,
        photoUrl,
        createdAt,
      ];
}

import 'package:recurseo/features/auth/domain/entities/user_entity.dart';

/// Modelo de usuario para serialización/deserialización
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.userType,
    super.phoneNumber,
    super.photoUrl,
    required super.createdAt,
  });

  /// Crear desde JSON (respuesta de API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      userType: _parseUserType(json['user_type'] as String),
      phoneNumber: json['phone_number'] as String?,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convertir a JSON (para enviar a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'user_type': _userTypeToString(userType),
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convertir desde entidad
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      userType: entity.userType,
      phoneNumber: entity.phoneNumber,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
    );
  }

  /// Helpers para parsear UserType
  static UserType _parseUserType(String type) {
    return switch (type.toLowerCase()) {
      'client' => UserType.client,
      'provider' => UserType.provider,
      _ => UserType.client,
    };
  }

  static String _userTypeToString(UserType type) {
    return switch (type) {
      UserType.client => 'client',
      UserType.provider => 'provider',
    };
  }
}

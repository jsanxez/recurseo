import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/profile/domain/entities/provider_profile_entity.dart';
import 'package:recurseo/features/profile/domain/entities/service_entity.dart';

/// Contrato del repositorio de perfiles
abstract class ProfileRepository {
  /// Actualizar perfil básico del usuario
  Future<Result<UserEntity>> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  });

  /// Obtener perfil de proveedor
  Future<Result<ProviderProfileEntity>> getProviderProfile(String userId);

  /// Crear/actualizar perfil de proveedor
  Future<Result<ProviderProfileEntity>> updateProviderProfile({
    required String userId,
    String? businessName,
    String? description,
    String? location,
    List<String>? services,
    List<String>? certifications,
  });

  /// Subir foto de perfil
  Future<Result<String>> uploadProfilePhoto({
    required String userId,
    required String filePath,
  });

  /// Agregar foto al portfolio
  Future<Result<void>> addPortfolioPhoto({
    required String userId,
    required String filePath,
  });

  /// Eliminar foto del portfolio
  Future<Result<void>> removePortfolioPhoto({
    required String userId,
    required String photoUrl,
  });

  /// Obtener servicios del proveedor
  Future<Result<List<ServiceEntity>>> getProviderServices(String providerId);

  /// Crear servicio
  Future<Result<ServiceEntity>> createService({
    required String providerId,
    required String categoryId,
    required String title,
    required String description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
  });

  /// Actualizar servicio
  Future<Result<ServiceEntity>> updateService({
    required String serviceId,
    String? title,
    String? description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
    bool? isActive,
  });

  /// Eliminar servicio
  Future<Result<void>> deleteService(String serviceId);
}

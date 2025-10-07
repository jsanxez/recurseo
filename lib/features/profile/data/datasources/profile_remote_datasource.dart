import 'package:dio/dio.dart';
import 'package:recurseo/core/config/api_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/auth/data/models/user_model.dart';
import 'package:recurseo/features/profile/data/models/provider_profile_model.dart';
import 'package:recurseo/features/profile/data/models/service_model.dart';

/// DataSource remoto para operaciones de perfil
class ProfileRemoteDataSource {
  final Dio _dio;
  final _logger = const Logger('ProfileRemoteDataSource');

  ProfileRemoteDataSource(this._dio);

  /// Actualizar perfil básico
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      _logger.info('Updating user profile: $userId');

      final response = await _dio.put(
        '${ApiConfig.users}/$userId',
        data: {
          if (name != null) 'name': name,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (photoUrl != null) 'photo_url': photoUrl,
        },
      );

      _logger.success('User profile updated');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to update user profile', e);
      throw _handleError(e);
    }
  }

  /// Obtener perfil de proveedor
  Future<ProviderProfileModel> getProviderProfile(String userId) async {
    try {
      _logger.info('Fetching provider profile: $userId');

      final response = await _dio.get('${ApiConfig.users}/$userId/provider-profile');

      _logger.success('Provider profile fetched');
      return ProviderProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to fetch provider profile', e);
      throw _handleError(e);
    }
  }

  /// Actualizar perfil de proveedor
  Future<ProviderProfileModel> updateProviderProfile({
    required String userId,
    String? businessName,
    String? description,
    String? location,
    List<String>? services,
    List<String>? certifications,
  }) async {
    try {
      _logger.info('Updating provider profile: $userId');

      final response = await _dio.put(
        '${ApiConfig.users}/$userId/provider-profile',
        data: {
          if (businessName != null) 'business_name': businessName,
          if (description != null) 'description': description,
          if (location != null) 'location': location,
          if (services != null) 'services': services,
          if (certifications != null) 'certifications': certifications,
        },
      );

      _logger.success('Provider profile updated');
      return ProviderProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to update provider profile', e);
      throw _handleError(e);
    }
  }

  /// Subir foto de perfil
  Future<String> uploadProfilePhoto({
    required String userId,
    required String filePath,
  }) async {
    try {
      _logger.info('Uploading profile photo');

      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '${ApiConfig.users}/$userId/photo',
        data: formData,
      );

      final photoUrl = response.data['photo_url'] as String;
      _logger.success('Profile photo uploaded: $photoUrl');
      return photoUrl;
    } on DioException catch (e) {
      _logger.error('Failed to upload profile photo', e);
      throw _handleError(e);
    }
  }

  /// Agregar foto al portfolio
  Future<void> addPortfolioPhoto({
    required String userId,
    required String filePath,
  }) async {
    try {
      _logger.info('Adding portfolio photo');

      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });

      await _dio.post(
        '${ApiConfig.users}/$userId/portfolio',
        data: formData,
      );

      _logger.success('Portfolio photo added');
    } on DioException catch (e) {
      _logger.error('Failed to add portfolio photo', e);
      throw _handleError(e);
    }
  }

  /// Eliminar foto del portfolio
  Future<void> removePortfolioPhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      _logger.info('Removing portfolio photo');

      await _dio.delete(
        '${ApiConfig.users}/$userId/portfolio',
        data: {'photo_url': photoUrl},
      );

      _logger.success('Portfolio photo removed');
    } on DioException catch (e) {
      _logger.error('Failed to remove portfolio photo', e);
      throw _handleError(e);
    }
  }

  /// Obtener servicios del proveedor
  Future<List<ServiceModel>> getProviderServices(String providerId) async {
    try {
      _logger.info('Fetching provider services: $providerId');

      final response = await _dio.get(
        ApiConfig.services,
        queryParameters: {'provider_id': providerId},
      );

      final services = (response.data as List<dynamic>)
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.success('Fetched ${services.length} services');
      return services;
    } on DioException catch (e) {
      _logger.error('Failed to fetch services', e);
      throw _handleError(e);
    }
  }

  /// Crear servicio
  Future<ServiceModel> createService({
    required String providerId,
    required String categoryId,
    required String title,
    required String description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
  }) async {
    try {
      _logger.info('Creating service: $title');

      final response = await _dio.post(
        ApiConfig.services,
        data: {
          'provider_id': providerId,
          'category_id': categoryId,
          'title': title,
          'description': description,
          'price_from': priceFrom,
          'price_to': priceTo,
          'price_unit': priceUnit,
        },
      );

      _logger.success('Service created');
      return ServiceModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to create service', e);
      throw _handleError(e);
    }
  }

  /// Actualizar servicio
  Future<ServiceModel> updateService({
    required String serviceId,
    String? title,
    String? description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
    bool? isActive,
  }) async {
    try {
      _logger.info('Updating service: $serviceId');

      final response = await _dio.put(
        '${ApiConfig.services}/$serviceId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (priceFrom != null) 'price_from': priceFrom,
          if (priceTo != null) 'price_to': priceTo,
          if (priceUnit != null) 'price_unit': priceUnit,
          if (isActive != null) 'is_active': isActive,
        },
      );

      _logger.success('Service updated');
      return ServiceModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to update service', e);
      throw _handleError(e);
    }
  }

  /// Eliminar servicio
  Future<void> deleteService(String serviceId) async {
    try {
      _logger.info('Deleting service: $serviceId');

      await _dio.delete('${ApiConfig.services}/$serviceId');

      _logger.success('Service deleted');
    } on DioException catch (e) {
      _logger.error('Failed to delete service', e);
      throw _handleError(e);
    }
  }

  /// Manejar errores
  Exception _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data['message'] as String?;

    return switch (statusCode) {
      400 => Exception(message ?? 'Datos inválidos'),
      401 => Exception(message ?? 'No autorizado'),
      403 => Exception(message ?? 'Acceso denegado'),
      404 => Exception(message ?? 'Recurso no encontrado'),
      500 => Exception('Error del servidor'),
      _ => Exception(message ?? 'Error de conexión'),
    };
  }
}

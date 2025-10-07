import 'package:dio/dio.dart';
import 'package:recurseo/core/config/api_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/profile/data/models/service_model.dart';
import 'package:recurseo/features/services/data/models/category_model.dart';

/// DataSource remoto para el catálogo de servicios
class CatalogRemoteDataSource {
  final Dio _dio;
  final _logger = const Logger('CatalogRemoteDataSource');

  CatalogRemoteDataSource(this._dio);

  /// Obtener todas las categorías
  Future<List<CategoryModel>> getCategories() async {
    try {
      _logger.info('Fetching categories');

      final response = await _dio.get(ApiConfig.categories);

      final categories = (response.data as List<dynamic>)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.success('Fetched ${categories.length} categories');
      return categories;
    } on DioException catch (e) {
      _logger.error('Failed to fetch categories', e);
      throw _handleError(e);
    }
  }

  /// Obtener categoría por ID
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      _logger.info('Fetching category: $id');

      final response = await _dio.get('${ApiConfig.categories}/$id');

      _logger.success('Category fetched');
      return CategoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to fetch category', e);
      throw _handleError(e);
    }
  }

  /// Obtener servicios por categoría
  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    try {
      _logger.info('Fetching services for category: $categoryId');

      final response = await _dio.get(
        ApiConfig.services,
        queryParameters: {'category_id': categoryId},
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

  /// Buscar servicios
  Future<List<ServiceModel>> searchServices({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      _logger.info('Searching services: $query');

      final response = await _dio.get(
        '${ApiConfig.services}/search',
        queryParameters: {
          'q': query,
          if (categoryId != null) 'category_id': categoryId,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
          if (minRating != null) 'min_rating': minRating,
        },
      );

      final services = (response.data as List<dynamic>)
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.success('Found ${services.length} services');
      return services;
    } on DioException catch (e) {
      _logger.error('Failed to search services', e);
      throw _handleError(e);
    }
  }

  /// Obtener servicio por ID
  Future<ServiceModel> getServiceById(String id) async {
    try {
      _logger.info('Fetching service: $id');

      final response = await _dio.get('${ApiConfig.services}/$id');

      _logger.success('Service fetched');
      return ServiceModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Failed to fetch service', e);
      throw _handleError(e);
    }
  }

  /// Obtener servicios destacados
  Future<List<ServiceModel>> getFeaturedServices() async {
    try {
      _logger.info('Fetching featured services');

      final response = await _dio.get(
        ApiConfig.services,
        queryParameters: {'featured': true},
      );

      final services = (response.data as List<dynamic>)
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.success('Fetched ${services.length} featured services');
      return services;
    } on DioException catch (e) {
      _logger.error('Failed to fetch featured services', e);
      throw _handleError(e);
    }
  }

  /// Obtener servicios recientes
  Future<List<ServiceModel>> getRecentServices({int limit = 10}) async {
    try {
      _logger.info('Fetching recent services');

      final response = await _dio.get(
        ApiConfig.services,
        queryParameters: {
          'sort': 'created_at',
          'order': 'desc',
          'limit': limit,
        },
      );

      final services = (response.data as List<dynamic>)
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.success('Fetched ${services.length} recent services');
      return services;
    } on DioException catch (e) {
      _logger.error('Failed to fetch recent services', e);
      throw _handleError(e);
    }
  }

  /// Agregar a favoritos
  Future<void> addToFavorites(String userId, String serviceId) async {
    try {
      _logger.info('Adding service to favorites: $serviceId');

      await _dio.post(
        '${ApiConfig.users}/$userId/favorites',
        data: {'service_id': serviceId},
      );

      _logger.success('Service added to favorites');
    } on DioException catch (e) {
      _logger.error('Failed to add to favorites', e);
      throw _handleError(e);
    }
  }

  /// Remover de favoritos
  Future<void> removeFromFavorites(String userId, String serviceId) async {
    try {
      _logger.info('Removing service from favorites: $serviceId');

      await _dio.delete(
        '${ApiConfig.users}/$userId/favorites/$serviceId',
      );

      _logger.success('Service removed from favorites');
    } on DioException catch (e) {
      _logger.error('Failed to remove from favorites', e);
      throw _handleError(e);
    }
  }

  /// Obtener favoritos del usuario
  Future<List<ServiceModel>> getFavoriteServices(String userId) async {
    try {
      _logger.info('Fetching favorite services');

      final response = await _dio.get('${ApiConfig.users}/$userId/favorites');

      final services = (response.data as List<dynamic>)
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.success('Fetched ${services.length} favorite services');
      return services;
    } on DioException catch (e) {
      _logger.error('Failed to fetch favorites', e);
      throw _handleError(e);
    }
  }

  /// Verificar si está en favoritos
  Future<bool> isFavorite(String userId, String serviceId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.users}/$userId/favorites/$serviceId',
      );

      return response.data['is_favorite'] as bool;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
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
      404 => Exception(message ?? 'Recurso no encontrado'),
      500 => Exception('Error del servidor'),
      _ => Exception(message ?? 'Error de conexión'),
    };
  }
}

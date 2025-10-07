import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/profile/domain/entities/service_entity.dart';
import 'package:recurseo/features/services/domain/entities/category_entity.dart';

/// Contrato del repositorio de catálogo (servicios y categorías)
abstract class CatalogRepository {
  /// Obtener todas las categorías
  Future<Result<List<CategoryEntity>>> getCategories();

  /// Obtener categoría por ID
  Future<Result<CategoryEntity>> getCategoryById(String id);

  /// Obtener servicios por categoría
  Future<Result<List<ServiceEntity>>> getServicesByCategory(String categoryId);

  /// Buscar servicios
  Future<Result<List<ServiceEntity>>> searchServices({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  });

  /// Obtener servicio por ID
  Future<Result<ServiceEntity>> getServiceById(String id);

  /// Obtener servicios destacados
  Future<Result<List<ServiceEntity>>> getFeaturedServices();

  /// Obtener servicios recientes
  Future<Result<List<ServiceEntity>>> getRecentServices({int limit = 10});

  /// Agregar servicio a favoritos
  Future<Result<void>> addToFavorites(String serviceId);

  /// Remover servicio de favoritos
  Future<Result<void>> removeFromFavorites(String serviceId);

  /// Obtener servicios favoritos del usuario
  Future<Result<List<ServiceEntity>>> getFavoriteServices();

  /// Verificar si un servicio está en favoritos
  Future<Result<bool>> isFavorite(String serviceId);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/profile/domain/entities/service_entity.dart';
import 'package:recurseo/features/services/data/datasources/catalog_remote_datasource.dart';
import 'package:recurseo/features/services/data/repositories/catalog_repository_impl.dart';
import 'package:recurseo/features/services/domain/entities/category_entity.dart';
import 'package:recurseo/features/services/domain/repositories/catalog_repository.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider del remote datasource
final catalogRemoteDataSourceProvider =
    Provider<CatalogRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CatalogRemoteDataSource(dio);
});

/// Provider del repositorio de catálogo
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final remoteDataSource = ref.watch(catalogRemoteDataSourceProvider);
  return CatalogRepositoryImpl(remoteDataSource: remoteDataSource, ref: ref);
});

/// Provider de categorías
final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getCategories();

  return switch (result) {
    Success(data: final categories) => categories,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de servicios destacados
final featuredServicesProvider = FutureProvider<List<ServiceEntity>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getFeaturedServices();

  return switch (result) {
    Success(data: final services) => services,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de servicios por categoría
final servicesByCategoryProvider =
    FutureProvider.family<List<ServiceEntity>, String>((ref, categoryId) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getServicesByCategory(categoryId);

  return switch (result) {
    Success(data: final services) => services,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de servicio por ID
final serviceByIdProvider =
    FutureProvider.family<ServiceEntity, String>((ref, serviceId) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getServiceById(serviceId);

  return switch (result) {
    Success(data: final service) => service,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de favoritos
final favoriteServicesProvider = FutureProvider<List<ServiceEntity>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final result = await repository.getFavoriteServices();

  return switch (result) {
    Success(data: final services) => services,
    Failure() => [],
  };
});

/// Provider de búsqueda
final searchServicesProvider = FutureProvider.family<List<ServiceEntity>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];

    final repository = ref.watch(catalogRepositoryProvider);
    final result = await repository.searchServices(query: query);

    return switch (result) {
      Success(data: final services) => services,
      Failure() => [],
    };
  },
);

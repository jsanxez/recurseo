import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/profile/domain/entities/service_entity.dart';
import 'package:recurseo/features/services/data/datasources/catalog_remote_datasource.dart';
import 'package:recurseo/features/services/domain/entities/category_entity.dart';
import 'package:recurseo/features/services/domain/repositories/catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Implementación del repositorio de catálogo
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _remoteDataSource;
  final Ref _ref;
  final _logger = const Logger('CatalogRepositoryImpl');

  CatalogRepositoryImpl({
    required CatalogRemoteDataSource remoteDataSource,
    required Ref ref,
  })  : _remoteDataSource = remoteDataSource,
        _ref = ref;

  String? get _currentUserId => _ref.read(currentUserProvider)?.id;

  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Success(categories);
    } catch (e, st) {
      _logger.error('Failed to get categories', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<CategoryEntity>> getCategoryById(String id) async {
    try {
      final category = await _remoteDataSource.getCategoryById(id);
      return Success(category);
    } catch (e, st) {
      _logger.error('Failed to get category', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ServiceEntity>>> getServicesByCategory(
      String categoryId) async {
    try {
      final services =
          await _remoteDataSource.getServicesByCategory(categoryId);
      return Success(services);
    } catch (e, st) {
      _logger.error('Failed to get services by category', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ServiceEntity>>> searchServices({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      final services = await _remoteDataSource.searchServices(
        query: query,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
      );
      return Success(services);
    } catch (e, st) {
      _logger.error('Failed to search services', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ServiceEntity>> getServiceById(String id) async {
    try {
      final service = await _remoteDataSource.getServiceById(id);
      return Success(service);
    } catch (e, st) {
      _logger.error('Failed to get service', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ServiceEntity>>> getFeaturedServices() async {
    try {
      final services = await _remoteDataSource.getFeaturedServices();
      return Success(services);
    } catch (e, st) {
      _logger.error('Failed to get featured services', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ServiceEntity>>> getRecentServices({int limit = 10}) async {
    try {
      final services = await _remoteDataSource.getRecentServices(limit: limit);
      return Success(services);
    } catch (e, st) {
      _logger.error('Failed to get recent services', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> addToFavorites(String serviceId) async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Failure(message: 'Usuario no autenticado');
    }

    try {
      await _remoteDataSource.addToFavorites(userId, serviceId);
      return const Success(null);
    } catch (e, st) {
      _logger.error('Failed to add to favorites', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> removeFromFavorites(String serviceId) async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Failure(message: 'Usuario no autenticado');
    }

    try {
      await _remoteDataSource.removeFromFavorites(userId, serviceId);
      return const Success(null);
    } catch (e, st) {
      _logger.error('Failed to remove from favorites', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ServiceEntity>>> getFavoriteServices() async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Failure(message: 'Usuario no autenticado');
    }

    try {
      final services = await _remoteDataSource.getFavoriteServices(userId);
      return Success(services);
    } catch (e, st) {
      _logger.error('Failed to get favorite services', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<bool>> isFavorite(String serviceId) async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Success(false);
    }

    try {
      final isFav = await _remoteDataSource.isFavorite(userId, serviceId);
      return Success(isFav);
    } catch (e, st) {
      _logger.error('Failed to check favorite', e, st);
      return const Success(false);
    }
  }
}

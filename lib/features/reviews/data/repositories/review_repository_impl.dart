import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/reviews/data/datasources/review_mock_datasource.dart';
import 'package:recurseo/features/reviews/data/datasources/review_remote_datasource.dart';
import 'package:recurseo/features/reviews/domain/entities/review_entity.dart';
import 'package:recurseo/features/reviews/domain/repositories/review_repository.dart';

/// Implementación del repositorio de reseñas
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource? _remoteDataSource;
  final ReviewMockDataSource? _mockDataSource;
  final Ref _ref;
  final _logger = const Logger('ReviewRepositoryImpl');

  ReviewRepositoryImpl({
    ReviewRemoteDataSource? remoteDataSource,
    ReviewMockDataSource? mockDataSource,
    required Ref ref,
  })  : _remoteDataSource = remoteDataSource,
        _mockDataSource = mockDataSource,
        _ref = ref {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for reviews');
    }
  }

  String get _currentUserId {
    final authState = _ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      return authState.user.id;
    }
    throw Exception('Usuario no autenticado');
  }

  String get _currentUserName {
    final authState = _ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      return authState.user.name;
    }
    throw Exception('Usuario no autenticado');
  }

  @override
  Future<Result<List<ReviewEntity>>> getServiceReviews(String serviceId) async {
    try {
      final reviews = AppConfig.useMockData
          ? await _mockDataSource!.getServiceReviews(serviceId)
          : await _remoteDataSource!.getServiceReviews(serviceId);
      return Success(reviews);
    } catch (e, st) {
      _logger.error('Failed to get service reviews', e, st);
      return Failure(
        message: 'Error al obtener reseñas del servicio',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ReviewEntity>>> getProviderReviews(
      String providerId) async {
    try {
      final reviews = AppConfig.useMockData
          ? await _mockDataSource!.getProviderReviews(providerId)
          : await _remoteDataSource!.getProviderReviews(providerId);
      return Success(reviews);
    } catch (e, st) {
      _logger.error('Failed to get provider reviews', e, st);
      return Failure(
        message: 'Error al obtener reseñas del proveedor',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ReviewEntity>> getReview(String reviewId) async {
    try {
      final review = AppConfig.useMockData
          ? await _mockDataSource!.getReview(reviewId)
          : await _remoteDataSource!.getReview(reviewId);
      return Success(review);
    } catch (e, st) {
      _logger.error('Failed to get review', e, st);
      return Failure(
        message: 'Error al obtener reseña',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ReviewEntity>> createReview({
    required String serviceId,
    required String providerId,
    required int rating,
    required String comment,
    String? requestId,
  }) async {
    try {
      final review = AppConfig.useMockData
          ? await _mockDataSource!.createReview(
              clientId: _currentUserId,
              clientName: _currentUserName,
              serviceId: serviceId,
              providerId: providerId,
              rating: rating,
              comment: comment,
              requestId: requestId,
            )
          : await _remoteDataSource!.createReview(
              serviceId: serviceId,
              providerId: providerId,
              rating: rating,
              comment: comment,
              requestId: requestId,
            );
      return Success(review);
    } catch (e, st) {
      _logger.error('Failed to create review', e, st);
      return Failure(
        message: 'Error al crear reseña',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ReviewEntity>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final review = AppConfig.useMockData
          ? await _mockDataSource!.updateReview(
              reviewId: reviewId,
              rating: rating,
              comment: comment,
            )
          : await _remoteDataSource!.updateReview(
              reviewId: reviewId,
              rating: rating,
              comment: comment,
            );
      return Success(review);
    } catch (e, st) {
      _logger.error('Failed to update review', e, st);
      return Failure(
        message: 'Error al actualizar reseña',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> deleteReview(String reviewId) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.deleteReview(reviewId);
      } else {
        await _remoteDataSource!.deleteReview(reviewId);
      }
      return const Success(null);
    } catch (e, st) {
      _logger.error('Failed to delete review', e, st);
      return Failure(
        message: 'Error al eliminar reseña',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<bool>> canReview({
    required String requestId,
    required String serviceId,
  }) async {
    try {
      final canReview = AppConfig.useMockData
          ? await _mockDataSource!.canReview(
              clientId: _currentUserId,
              requestId: requestId,
              serviceId: serviceId,
            )
          : await _remoteDataSource!.canReview(
              requestId: requestId,
              serviceId: serviceId,
            );
      return Success(canReview);
    } catch (e, st) {
      _logger.error('Failed to check can review', e, st);
      return Failure(
        message: 'Error al verificar si puede dejar reseña',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ReviewStats>> getServiceReviewStats(String serviceId) async {
    try {
      final stats = AppConfig.useMockData
          ? await _mockDataSource!.getServiceReviewStats(serviceId)
          : await _remoteDataSource!.getServiceReviewStats(serviceId);
      return Success(stats);
    } catch (e, st) {
      _logger.error('Failed to get service review stats', e, st);
      return Failure(
        message: 'Error al obtener estadísticas de reseñas',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ReviewStats>> getProviderReviewStats(String providerId) async {
    try {
      final stats = AppConfig.useMockData
          ? await _mockDataSource!.getProviderReviewStats(providerId)
          : await _remoteDataSource!.getProviderReviewStats(providerId);
      return Success(stats);
    } catch (e, st) {
      _logger.error('Failed to get provider review stats', e, st);
      return Failure(
        message: 'Error al obtener estadísticas de reseñas del proveedor',
        error: e,
        stackTrace: st,
      );
    }
  }
}

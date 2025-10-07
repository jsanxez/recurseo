import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/reviews/data/datasources/review_mock_datasource.dart';
import 'package:recurseo/features/reviews/data/datasources/review_remote_datasource.dart';
import 'package:recurseo/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:recurseo/features/reviews/domain/entities/review_entity.dart';
import 'package:recurseo/features/reviews/domain/repositories/review_repository.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider del remote datasource
final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ReviewRemoteDataSource(dio);
});

/// Provider del mock datasource
final reviewMockDataSourceProvider = Provider<ReviewMockDataSource>((ref) {
  return ReviewMockDataSource();
});

/// Provider del repositorio de reseñas
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  if (AppConfig.useMockData) {
    final mockDataSource = ref.watch(reviewMockDataSourceProvider);
    return ReviewRepositoryImpl(
      mockDataSource: mockDataSource,
      ref: ref,
    );
  } else {
    final remoteDataSource = ref.watch(reviewRemoteDataSourceProvider);
    return ReviewRepositoryImpl(
      remoteDataSource: remoteDataSource,
      ref: ref,
    );
  }
});

/// Provider de reseñas de un servicio
final serviceReviewsProvider =
    FutureProvider.family<List<ReviewEntity>, String>((ref, serviceId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getServiceReviews(serviceId);

  return switch (result) {
    Success(data: final reviews) => reviews,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de reseñas de un proveedor
final providerReviewsProvider =
    FutureProvider.family<List<ReviewEntity>, String>((ref, providerId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getProviderReviews(providerId);

  return switch (result) {
    Success(data: final reviews) => reviews,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de estadísticas de reseñas de un servicio
final serviceReviewStatsProvider =
    FutureProvider.family<ReviewStats, String>((ref, serviceId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getServiceReviewStats(serviceId);

  return switch (result) {
    Success(data: final stats) => stats,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de estadísticas de reseñas de un proveedor
final providerReviewStatsProvider =
    FutureProvider.family<ReviewStats, String>((ref, providerId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getProviderReviewStats(providerId);

  return switch (result) {
    Success(data: final stats) => stats,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider para verificar si puede dejar reseña
final canReviewProvider = FutureProvider.family<bool, CanReviewParams>(
  (ref, params) async {
    final repository = ref.watch(reviewRepositoryProvider);
    final result = await repository.canReview(
      requestId: params.requestId,
      serviceId: params.serviceId,
    );

    return switch (result) {
      Success(data: final canReview) => canReview,
      Failure() => false,
    };
  },
);

/// Parámetros para verificar si puede dejar reseña
class CanReviewParams {
  final String requestId;
  final String serviceId;

  const CanReviewParams({
    required this.requestId,
    required this.serviceId,
  });
}

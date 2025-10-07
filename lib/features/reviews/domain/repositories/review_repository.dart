import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/reviews/domain/entities/review_entity.dart';

/// Repositorio de reseñas
abstract class ReviewRepository {
  /// Obtener reseñas de un servicio
  Future<Result<List<ReviewEntity>>> getServiceReviews(String serviceId);

  /// Obtener reseñas de un proveedor
  Future<Result<List<ReviewEntity>>> getProviderReviews(String providerId);

  /// Obtener una reseña específica
  Future<Result<ReviewEntity>> getReview(String reviewId);

  /// Crear una nueva reseña
  Future<Result<ReviewEntity>> createReview({
    required String serviceId,
    required String providerId,
    required int rating,
    required String comment,
    String? requestId,
  });

  /// Actualizar una reseña propia
  Future<Result<ReviewEntity>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  });

  /// Eliminar una reseña propia
  Future<Result<void>> deleteReview(String reviewId);

  /// Verificar si el usuario puede dejar reseña para una solicitud
  Future<Result<bool>> canReview({
    required String requestId,
    required String serviceId,
  });

  /// Obtener estadísticas de reseñas de un servicio
  Future<Result<ReviewStats>> getServiceReviewStats(String serviceId);

  /// Obtener estadísticas de reseñas de un proveedor
  Future<Result<ReviewStats>> getProviderReviewStats(String providerId);
}

/// Estadísticas de reseñas
class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count
  final int verifiedReviews;

  const ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.verifiedReviews,
  });

  /// Obtener porcentaje de reseñas positivas (4-5 estrellas)
  double get positivePercentage {
    if (totalReviews == 0) return 0;
    final positiveCount = (ratingDistribution[4] ?? 0) + (ratingDistribution[5] ?? 0);
    return (positiveCount / totalReviews) * 100;
  }
}

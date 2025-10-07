import 'package:dio/dio.dart';
import 'package:recurseo/core/config/api_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/reviews/data/models/review_model.dart';
import 'package:recurseo/features/reviews/domain/repositories/review_repository.dart';

/// DataSource remoto para reseñas
class ReviewRemoteDataSource {
  final Dio _dio;
  final _logger = const Logger('ReviewRemoteDataSource');

  ReviewRemoteDataSource(this._dio);

  Future<List<ReviewModel>> getServiceReviews(String serviceId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.services}/$serviceId/reviews',
      );

      return (response.data as List<dynamic>)
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logger.error('Get service reviews failed', e);
      throw _handleError(e);
    }
  }

  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.providers}/$providerId/reviews',
      );

      return (response.data as List<dynamic>)
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logger.error('Get provider reviews failed', e);
      throw _handleError(e);
    }
  }

  Future<ReviewModel> getReview(String reviewId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.reviews}/$reviewId',
      );

      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Get review failed', e);
      throw _handleError(e);
    }
  }

  Future<ReviewModel> createReview({
    required String serviceId,
    required String providerId,
    required int rating,
    required String comment,
    String? requestId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.reviews,
        data: {
          'service_id': serviceId,
          'provider_id': providerId,
          'rating': rating,
          'comment': comment,
          if (requestId != null) 'request_id': requestId,
        },
      );

      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Create review failed', e);
      throw _handleError(e);
    }
  }

  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.reviews}/$reviewId',
        data: {
          if (rating != null) 'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );

      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Update review failed', e);
      throw _handleError(e);
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _dio.delete('${ApiConfig.reviews}/$reviewId');
    } on DioException catch (e) {
      _logger.error('Delete review failed', e);
      throw _handleError(e);
    }
  }

  Future<bool> canReview({
    required String requestId,
    required String serviceId,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.reviews}/can-review',
        queryParameters: {
          'request_id': requestId,
          'service_id': serviceId,
        },
      );

      return response.data['can_review'] as bool;
    } on DioException catch (e) {
      _logger.error('Check can review failed', e);
      throw _handleError(e);
    }
  }

  Future<ReviewStats> getServiceReviewStats(String serviceId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.services}/$serviceId/reviews/stats',
      );

      final data = response.data as Map<String, dynamic>;
      return ReviewStats(
        averageRating: (data['average_rating'] as num).toDouble(),
        totalReviews: data['total_reviews'] as int,
        ratingDistribution: Map<int, int>.from(data['rating_distribution'] as Map),
        verifiedReviews: data['verified_reviews'] as int,
      );
    } on DioException catch (e) {
      _logger.error('Get service review stats failed', e);
      throw _handleError(e);
    }
  }

  Future<ReviewStats> getProviderReviewStats(String providerId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.providers}/$providerId/reviews/stats',
      );

      final data = response.data as Map<String, dynamic>;
      return ReviewStats(
        averageRating: (data['average_rating'] as num).toDouble(),
        totalReviews: data['total_reviews'] as int,
        ratingDistribution: Map<int, int>.from(data['rating_distribution'] as Map),
        verifiedReviews: data['verified_reviews'] as int,
      );
    } on DioException catch (e) {
      _logger.error('Get provider review stats failed', e);
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return Exception(data['message']);
      }
    }
    return Exception('Error de conexión con el servidor');
  }
}

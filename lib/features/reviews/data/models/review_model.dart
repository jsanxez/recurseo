import 'package:recurseo/features/reviews/domain/entities/review_entity.dart';

/// Modelo de reseña para serialización
class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.serviceId,
    required super.clientId,
    required super.clientName,
    super.clientPhotoUrl,
    required super.providerId,
    required super.rating,
    required super.comment,
    super.isVerified,
    super.requestId,
    required super.createdAt,
    super.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String,
      clientPhotoUrl: json['client_photo_url'] as String?,
      providerId: json['provider_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      requestId: json['request_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'client_id': clientId,
      'client_name': clientName,
      'client_photo_url': clientPhotoUrl,
      'provider_id': providerId,
      'rating': rating,
      'comment': comment,
      'is_verified': isVerified,
      'request_id': requestId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      serviceId: entity.serviceId,
      clientId: entity.clientId,
      clientName: entity.clientName,
      clientPhotoUrl: entity.clientPhotoUrl,
      providerId: entity.providerId,
      rating: entity.rating,
      comment: entity.comment,
      isVerified: entity.isVerified,
      requestId: entity.requestId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

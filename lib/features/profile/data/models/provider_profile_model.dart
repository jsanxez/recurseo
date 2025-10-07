import 'package:recurseo/features/profile/domain/entities/provider_profile_entity.dart';

/// Modelo de perfil de proveedor para serialización
class ProviderProfileModel extends ProviderProfileEntity {
  const ProviderProfileModel({
    required super.userId,
    required super.businessName,
    required super.description,
    required super.services,
    super.location,
    required super.rating,
    required super.reviewsCount,
    required super.completedJobs,
    required super.photoUrls,
    required super.certifications,
    required super.isVerified,
    required super.memberSince,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      userId: json['user_id'] as String,
      businessName: json['business_name'] as String,
      description: json['description'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int,
      completedJobs: json['completed_jobs'] as int,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isVerified: json['is_verified'] as bool,
      memberSince: DateTime.parse(json['member_since'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'business_name': businessName,
      'description': description,
      'services': services,
      'location': location,
      'rating': rating,
      'reviews_count': reviewsCount,
      'completed_jobs': completedJobs,
      'photo_urls': photoUrls,
      'certifications': certifications,
      'is_verified': isVerified,
      'member_since': memberSince.toIso8601String(),
    };
  }

  factory ProviderProfileModel.fromEntity(ProviderProfileEntity entity) {
    return ProviderProfileModel(
      userId: entity.userId,
      businessName: entity.businessName,
      description: entity.description,
      services: entity.services,
      location: entity.location,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      completedJobs: entity.completedJobs,
      photoUrls: entity.photoUrls,
      certifications: entity.certifications,
      isVerified: entity.isVerified,
      memberSince: entity.memberSince,
    );
  }
}

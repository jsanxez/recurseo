import 'package:equatable/equatable.dart';

/// Entidad de perfil de proveedor (información extendida)
class ProviderProfileEntity extends Equatable {
  final String userId;
  final String businessName;
  final String description;
  final List<String> services; // IDs de servicios
  final String? location;
  final double rating;
  final int reviewsCount;
  final int completedJobs;
  final List<String> photoUrls;
  final List<String> certifications;
  final bool isVerified;
  final DateTime memberSince;

  const ProviderProfileEntity({
    required this.userId,
    required this.businessName,
    required this.description,
    required this.services,
    this.location,
    required this.rating,
    required this.reviewsCount,
    required this.completedJobs,
    required this.photoUrls,
    required this.certifications,
    required this.isVerified,
    required this.memberSince,
  });

  ProviderProfileEntity copyWith({
    String? userId,
    String? businessName,
    String? description,
    List<String>? services,
    String? location,
    double? rating,
    int? reviewsCount,
    int? completedJobs,
    List<String>? photoUrls,
    List<String>? certifications,
    bool? isVerified,
    DateTime? memberSince,
  }) {
    return ProviderProfileEntity(
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      description: description ?? this.description,
      services: services ?? this.services,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      completedJobs: completedJobs ?? this.completedJobs,
      photoUrls: photoUrls ?? this.photoUrls,
      certifications: certifications ?? this.certifications,
      isVerified: isVerified ?? this.isVerified,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        businessName,
        description,
        services,
        location,
        rating,
        reviewsCount,
        completedJobs,
        photoUrls,
        certifications,
        isVerified,
        memberSince,
      ];
}

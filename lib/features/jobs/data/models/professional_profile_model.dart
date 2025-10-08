import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';

/// Modelo de datos para ProfessionalProfile (serialización)
class ProfessionalProfileModel extends ProfessionalProfileEntity {
  const ProfessionalProfileModel({
    required super.userId,
    super.specialties,
    super.trades,
    super.experienceYears,
    super.availability,
    super.preferredLocations,
    super.hasOwnTools,
    super.certifications,
    super.portfolioUrls,
    super.hourlyRate,
    super.dailyRate,
    super.lookingForWork,
    required super.lastActive,
    super.bio,
    super.averageRating,
    super.completedJobs,
    super.reviewsCount,
  });

  /// Crear desde JSON
  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      userId: json['user_id'] as String,
      specialties: json['specialties'] != null
          ? (json['specialties'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      trades: json['trades'] != null
          ? (json['trades'] as List<dynamic>)
              .map((e) => Trade.values.firstWhere(
                    (t) => t.name == e,
                    orElse: () => Trade.operario,
                  ))
              .toList()
          : [],
      experienceYears: json['experience_years'] as int? ?? 0,
      availability: json['availability'] != null
          ? AvailabilityStatus.values.firstWhere(
              (e) => e.name == json['availability'],
              orElse: () => AvailabilityStatus.disponible,
            )
          : AvailabilityStatus.disponible,
      preferredLocations: json['preferred_locations'] != null
          ? (json['preferred_locations'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      hasOwnTools: json['has_own_tools'] as bool? ?? false,
      certifications: json['certifications'] != null
          ? (json['certifications'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      portfolioUrls: json['portfolio_urls'] != null
          ? (json['portfolio_urls'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      hourlyRate: json['hourly_rate'] != null
          ? (json['hourly_rate'] as num).toDouble()
          : null,
      dailyRate: json['daily_rate'] != null
          ? (json['daily_rate'] as num).toDouble()
          : null,
      lookingForWork: json['looking_for_work'] as bool? ?? true,
      lastActive: DateTime.parse(json['last_active'] as String),
      bio: json['bio'] as String?,
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
      completedJobs: json['completed_jobs'] as int? ?? 0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'specialties': specialties,
      'trades': trades.map((e) => e.name).toList(),
      'experience_years': experienceYears,
      'availability': availability.name,
      'preferred_locations': preferredLocations,
      'has_own_tools': hasOwnTools,
      'certifications': certifications,
      'portfolio_urls': portfolioUrls,
      'hourly_rate': hourlyRate,
      'daily_rate': dailyRate,
      'looking_for_work': lookingForWork,
      'last_active': lastActive.toIso8601String(),
      'bio': bio,
      'average_rating': averageRating,
      'completed_jobs': completedJobs,
      'reviews_count': reviewsCount,
    };
  }

  /// Crear desde entidad
  factory ProfessionalProfileModel.fromEntity(
      ProfessionalProfileEntity entity) {
    return ProfessionalProfileModel(
      userId: entity.userId,
      specialties: entity.specialties,
      trades: entity.trades,
      experienceYears: entity.experienceYears,
      availability: entity.availability,
      preferredLocations: entity.preferredLocations,
      hasOwnTools: entity.hasOwnTools,
      certifications: entity.certifications,
      portfolioUrls: entity.portfolioUrls,
      hourlyRate: entity.hourlyRate,
      dailyRate: entity.dailyRate,
      lookingForWork: entity.lookingForWork,
      lastActive: entity.lastActive,
      bio: entity.bio,
      averageRating: entity.averageRating,
      completedJobs: entity.completedJobs,
      reviewsCount: entity.reviewsCount,
    );
  }

  /// Copiar con nuevos valores
  ProfessionalProfileModel copyWith({
    String? userId,
    List<String>? specialties,
    List<Trade>? trades,
    int? experienceYears,
    AvailabilityStatus? availability,
    List<String>? preferredLocations,
    bool? hasOwnTools,
    List<String>? certifications,
    List<String>? portfolioUrls,
    double? hourlyRate,
    double? dailyRate,
    bool? lookingForWork,
    DateTime? lastActive,
    String? bio,
    double? averageRating,
    int? completedJobs,
    int? reviewsCount,
  }) {
    return ProfessionalProfileModel(
      userId: userId ?? this.userId,
      specialties: specialties ?? this.specialties,
      trades: trades ?? this.trades,
      experienceYears: experienceYears ?? this.experienceYears,
      availability: availability ?? this.availability,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      hasOwnTools: hasOwnTools ?? this.hasOwnTools,
      certifications: certifications ?? this.certifications,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      dailyRate: dailyRate ?? this.dailyRate,
      lookingForWork: lookingForWork ?? this.lookingForWork,
      lastActive: lastActive ?? this.lastActive,
      bio: bio ?? this.bio,
      averageRating: averageRating ?? this.averageRating,
      completedJobs: completedJobs ?? this.completedJobs,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}

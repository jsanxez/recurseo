import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';

/// Modelo de datos para ProfessionalProfile (serialización)
class ProfessionalProfileModel extends ProfessionalProfileEntity {
  const ProfessionalProfileModel({
    super.id,
    required super.userId,
    super.specialties,
    super.trades,
    super.experienceYears,
    super.availability,
    super.preferredLocations,
    super.hasOwnTools,
    super.hasOwnTransport,
    super.skills,
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
    super.serviceRadius,
    super.preferredPaymentType,
    super.willingToTravel,
    super.languages,
    super.completedProjects,
    super.totalReviews,
    super.createdAt,
    super.updatedAt,
  });

  /// Crear desde JSON
  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      id: json['id'] as String?,
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
      hasOwnTransport: json['has_own_transport'] as bool?,
      skills: json['skills'] != null
          ? (json['skills'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : null,
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
      serviceRadius: json['service_radius'] != null
          ? (json['service_radius'] as num).toDouble()
          : null,
      preferredPaymentType: json['preferred_payment_type'] != null
          ? PaymentType.values.firstWhere(
              (e) => e.name == json['preferred_payment_type'],
              orElse: () => PaymentType.porDia,
            )
          : null,
      willingToTravel: json['willing_to_travel'] as bool?,
      languages: json['languages'] != null
          ? (json['languages'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : null,
      completedProjects: json['completed_projects'] as int?,
      totalReviews: json['total_reviews'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'specialties': specialties,
      'trades': trades.map((e) => e.name).toList(),
      'experience_years': experienceYears,
      'availability': availability.name,
      'preferred_locations': preferredLocations,
      'has_own_tools': hasOwnTools,
      'has_own_transport': hasOwnTransport,
      'skills': skills,
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
      'service_radius': serviceRadius,
      'preferred_payment_type': preferredPaymentType?.name,
      'willing_to_travel': willingToTravel,
      'languages': languages,
      'completed_projects': completedProjects,
      'total_reviews': totalReviews,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Crear desde entidad
  factory ProfessionalProfileModel.fromEntity(
      ProfessionalProfileEntity entity) {
    return ProfessionalProfileModel(
      id: entity.id,
      userId: entity.userId,
      specialties: entity.specialties,
      trades: entity.trades,
      experienceYears: entity.experienceYears,
      availability: entity.availability,
      preferredLocations: entity.preferredLocations,
      hasOwnTools: entity.hasOwnTools,
      hasOwnTransport: entity.hasOwnTransport,
      skills: entity.skills,
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
      serviceRadius: entity.serviceRadius,
      preferredPaymentType: entity.preferredPaymentType,
      willingToTravel: entity.willingToTravel,
      languages: entity.languages,
      completedProjects: entity.completedProjects,
      totalReviews: entity.totalReviews,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Copiar con nuevos valores
  @override
  ProfessionalProfileModel copyWith({
    String? id,
    String? userId,
    List<String>? specialties,
    List<Trade>? trades,
    int? experienceYears,
    AvailabilityStatus? availability,
    List<String>? preferredLocations,
    bool? hasOwnTools,
    bool? hasOwnTransport,
    List<String>? skills,
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
    double? serviceRadius,
    PaymentType? preferredPaymentType,
    bool? willingToTravel,
    List<String>? languages,
    int? completedProjects,
    int? totalReviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfessionalProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      specialties: specialties ?? this.specialties,
      trades: trades ?? this.trades,
      experienceYears: experienceYears ?? this.experienceYears,
      availability: availability ?? this.availability,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      hasOwnTools: hasOwnTools ?? this.hasOwnTools,
      hasOwnTransport: hasOwnTransport ?? this.hasOwnTransport,
      skills: skills ?? this.skills,
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
      serviceRadius: serviceRadius ?? this.serviceRadius,
      preferredPaymentType: preferredPaymentType ?? this.preferredPaymentType,
      willingToTravel: willingToTravel ?? this.willingToTravel,
      languages: languages ?? this.languages,
      completedProjects: completedProjects ?? this.completedProjects,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

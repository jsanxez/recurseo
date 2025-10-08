import 'package:equatable/equatable.dart';

/// Oficios/especialidades en construcción
enum Trade {
  electricista,
  plomero,
  albanil,
  carpintero,
  pintor,
  operario,
  maestroObra,
  soldador,
  herrero,
  jardinero,
  limpieza,
  ayudante,
}

/// Estado de disponibilidad del profesional
enum AvailabilityStatus {
  disponible, // Disponible para trabajar ahora
  ocupado, // No disponible (trabajando en otro proyecto)
  parcial, // Parcialmente disponible (puede tomar trabajos pequeños)
}

/// Entidad de perfil profesional
///
/// Extiende UserEntity con información específica para profesionales
/// que buscan trabajo en el sector construcción.
class ProfessionalProfileEntity extends Equatable {
  /// ID del usuario
  final String userId;

  /// Especialidades del profesional (puede tener varias)
  final List<String> specialties;

  /// Oficios que domina
  final List<Trade> trades;

  /// Años de experiencia
  final int experienceYears;

  /// Estado de disponibilidad actual
  final AvailabilityStatus availability;

  /// Ubicaciones preferidas para trabajar
  final List<String> preferredLocations;

  /// Tiene herramientas propias
  final bool hasOwnTools;

  /// Certificaciones o cursos (opcional)
  final List<String> certifications;

  /// URLs de fotos del portfolio (trabajos realizados)
  final List<String> portfolioUrls;

  /// Tarifa por hora (opcional)
  final double? hourlyRate;

  /// Tarifa por día (opcional)
  final double? dailyRate;

  /// Está activamente buscando trabajo
  final bool lookingForWork;

  /// Última vez que estuvo activo en la app
  final DateTime lastActive;

  /// Descripción/biografía del profesional
  final String? bio;

  /// Calificación promedio (de 1 a 5)
  final double? averageRating;

  /// Total de trabajos completados
  final int completedJobs;

  /// Total de reseñas recibidas
  final int reviewsCount;

  const ProfessionalProfileEntity({
    required this.userId,
    this.specialties = const [],
    this.trades = const [],
    this.experienceYears = 0,
    this.availability = AvailabilityStatus.disponible,
    this.preferredLocations = const [],
    this.hasOwnTools = false,
    this.certifications = const [],
    this.portfolioUrls = const [],
    this.hourlyRate,
    this.dailyRate,
    this.lookingForWork = true,
    required this.lastActive,
    this.bio,
    this.averageRating,
    this.completedJobs = 0,
    this.reviewsCount = 0,
  });

  /// Obtener texto legible del estado de disponibilidad
  String get availabilityText {
    return switch (availability) {
      AvailabilityStatus.disponible => 'Disponible',
      AvailabilityStatus.ocupado => 'Ocupado',
      AvailabilityStatus.parcial => 'Parcialmente disponible',
    };
  }

  /// Obtener lista de nombres de oficios
  List<String> get tradeNames {
    return trades.map((trade) {
      return switch (trade) {
        Trade.electricista => 'Electricista',
        Trade.plomero => 'Plomero',
        Trade.albanil => 'Albañil',
        Trade.carpintero => 'Carpintero',
        Trade.pintor => 'Pintor',
        Trade.operario => 'Operario',
        Trade.maestroObra => 'Maestro de Obra',
        Trade.soldador => 'Soldador',
        Trade.herrero => 'Herrero',
        Trade.jardinero => 'Jardinero',
        Trade.limpieza => 'Limpieza',
        Trade.ayudante => 'Ayudante',
      };
    }).toList();
  }

  /// Verificar si está disponible
  bool get isAvailable {
    return availability == AvailabilityStatus.disponible;
  }

  /// Verificar si está buscando trabajo activamente
  bool get isActiveLookingForWork {
    return lookingForWork && availability != AvailabilityStatus.ocupado;
  }

  /// Verificar si fue activo recientemente (últimas 24 horas)
  bool get isRecentlyActive {
    final diff = DateTime.now().difference(lastActive);
    return diff.inHours < 24;
  }

  /// Horas desde última actividad
  int get hoursSinceLastActive {
    return DateTime.now().difference(lastActive).inHours;
  }

  /// Obtener tarifa preferida (hourly si existe, sino daily)
  String? get preferredRate {
    if (hourlyRate != null) {
      return '\$${hourlyRate!.toStringAsFixed(0)}/hora';
    } else if (dailyRate != null) {
      return '\$${dailyRate!.toStringAsFixed(0)}/día';
    }
    return null;
  }

  /// Verificar si tiene buena reputación (rating >= 4.0)
  bool get hasGoodReputation {
    return averageRating != null && averageRating! >= 4.0;
  }

  /// Verificar si es profesional verificado (tiene trabajos completados)
  bool get isVerified {
    return completedJobs > 0;
  }

  ProfessionalProfileEntity copyWith({
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
    return ProfessionalProfileEntity(
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

  @override
  List<Object?> get props => [
        userId,
        specialties,
        trades,
        experienceYears,
        availability,
        preferredLocations,
        hasOwnTools,
        certifications,
        portfolioUrls,
        hourlyRate,
        dailyRate,
        lookingForWork,
        lastActive,
        bio,
        averageRating,
        completedJobs,
        reviewsCount,
      ];
}

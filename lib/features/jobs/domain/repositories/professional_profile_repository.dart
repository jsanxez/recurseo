import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';

/// Filtros para búsqueda de profesionales
class ProfessionalSearchFilters {
  final List<Trade>? trades;
  final String? location;
  final AvailabilityStatus? availability;
  final bool? hasOwnTools;
  final int? minExperience;
  final double? minRating;
  final bool? onlyLookingForWork;

  const ProfessionalSearchFilters({
    this.trades,
    this.location,
    this.availability,
    this.hasOwnTools,
    this.minExperience,
    this.minRating,
    this.onlyLookingForWork = true,
  });
}

/// Opciones de ordenamiento para profesionales
enum ProfessionalSortOption {
  rating, // Mayor calificación primero
  experience, // Más experiencia primero
  recentActivity, // Más recientemente activos primero
  completedJobs, // Más trabajos completados primero
}

/// Repositorio de perfiles profesionales
abstract class ProfessionalProfileRepository {
  /// Obtener perfil profesional por ID de usuario
  Future<Result<ProfessionalProfileEntity>> getProfessionalProfile(
    String userId,
  );

  /// Buscar profesionales (con filtros opcionales)
  Future<Result<List<ProfessionalProfileEntity>>> searchProfessionals({
    ProfessionalSearchFilters? filters,
    ProfessionalSortOption? sortBy,
    int? limit,
  });

  /// Crear perfil profesional
  Future<Result<ProfessionalProfileEntity>> createProfessionalProfile({
    required String userId,
    required List<String> specialties,
    required List<Trade> trades,
    required int experienceYears,
    List<String>? preferredLocations,
    bool? hasOwnTools,
    List<String>? certifications,
    List<String>? portfolioUrls,
    double? hourlyRate,
    double? dailyRate,
    String? bio,
  });

  /// Actualizar perfil profesional
  Future<Result<ProfessionalProfileEntity>> updateProfessionalProfile({
    required String userId,
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
    String? bio,
  });

  /// Actualizar estado de disponibilidad
  Future<Result<void>> updateAvailability({
    required String userId,
    required AvailabilityStatus availability,
  });

  /// Actualizar estado de búsqueda de trabajo
  Future<Result<void>> updateLookingForWork({
    required String userId,
    required bool lookingForWork,
  });

  /// Actualizar última actividad
  Future<Result<void>> updateLastActive(String userId);

  /// Agregar foto al portfolio
  Future<Result<void>> addPortfolioPhoto({
    required String userId,
    required String photoUrl,
  });

  /// Eliminar foto del portfolio
  Future<Result<void>> removePortfolioPhoto({
    required String userId,
    required String photoUrl,
  });

  /// Actualizar estadísticas después de completar trabajo
  Future<Result<void>> updateJobStats({
    required String userId,
    required double newRating,
  });
}

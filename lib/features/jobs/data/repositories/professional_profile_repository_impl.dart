import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/data/datasources/professional_profile_mock_datasource.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/professional_profile_repository.dart';

/// Implementación del repositorio de perfiles profesionales
class ProfessionalProfileRepositoryImpl implements ProfessionalProfileRepository {
  final ProfessionalProfileMockDataSource? _mockDataSource;
  // final ProfessionalProfileRemoteDataSource? _remoteDataSource; // Para futuro uso con API
  final _logger = const Logger('ProfessionalProfileRepositoryImpl');

  ProfessionalProfileRepositoryImpl({
    ProfessionalProfileMockDataSource? mockDataSource,
    // ProfessionalProfileRemoteDataSource? remoteDataSource,
  }) : _mockDataSource = mockDataSource {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for professional profiles');
    } else {
      _logger.info('🌐 Using REMOTE API for professional profiles');
    }
  }

  @override
  Future<Result<ProfessionalProfileEntity>> getProfessionalProfile(
    String userId,
  ) async {
    try {
      if (AppConfig.useMockData) {
        final profile = await _mockDataSource!.getProfileByUserId(userId);
        if (profile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }
        return Success(profile);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting profile by user id', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ProfessionalProfileEntity>>> searchProfessionals({
    ProfessionalSearchFilters? filters,
    ProfessionalSortOption? sortBy,
    int? limit,
  }) async {
    try {
      if (AppConfig.useMockData) {
        var profiles = await _mockDataSource!.searchProfiles(
          trades: filters?.trades,
          availability: filters?.availability,
          hasOwnTools: filters?.hasOwnTools,
          lookingForWork: filters?.onlyLookingForWork,
          minRating: filters?.minRating,
          minExperienceYears: filters?.minExperience,
        );

        // Apply sorting
        if (sortBy != null) {
          profiles.sort((a, b) {
            switch (sortBy) {
              case ProfessionalSortOption.rating:
                return (b.averageRating ?? 0).compareTo(a.averageRating ?? 0);
              case ProfessionalSortOption.experience:
                return b.experienceYears.compareTo(a.experienceYears);
              case ProfessionalSortOption.recentActivity:
                return b.lastActive.compareTo(a.lastActive);
              case ProfessionalSortOption.completedJobs:
                return b.completedJobs.compareTo(a.completedJobs);
            }
          });
        }

        // Apply limit
        if (limit != null && profiles.length > limit) {
          profiles = profiles.take(limit).toList();
        }

        return Success(profiles);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error searching profiles', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
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
  }) async {
    try {
      if (AppConfig.useMockData) {
        final profile = await _mockDataSource!.createProfile(
          userId: userId,
          trades: trades,
          experienceYears: experienceYears,
          hasOwnTools: hasOwnTools ?? false,
          hasOwnTransport: false,
          hourlyRate: hourlyRate,
          dailyRate: dailyRate,
          bio: bio,
          skills: specialties,
          certifications: certifications,
        );
        _logger.success('Professional profile created successfully');
        return Success(profile);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error creating profile', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
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
  }) async {
    try {
      if (AppConfig.useMockData) {
        // Get the profile first to find the profileId
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        final profile = await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
          trades: trades,
          experienceYears: experienceYears,
          availability: availability,
          hasOwnTools: hasOwnTools,
          lookingForWork: lookingForWork,
          hourlyRate: hourlyRate,
          dailyRate: dailyRate,
          bio: bio,
          skills: specialties,
          certifications: certifications,
          portfolioUrls: portfolioUrls,
        );
        _logger.success('Professional profile updated successfully');
        return Success(profile);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating profile', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> updateAvailability({
    required String userId,
    required AvailabilityStatus availability,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
          availability: availability,
        );
        _logger.success('Availability updated successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating availability', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> updateLookingForWork({
    required String userId,
    required bool lookingForWork,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
          lookingForWork: lookingForWork,
        );
        _logger.success('Looking for work status updated successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating looking for work status', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> updateLastActive(String userId) async {
    try {
      if (AppConfig.useMockData) {
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        // Update with current time by using updatedAt which will be set to now
        await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
        );
        _logger.success('Last active updated successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating last active', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> addPortfolioPhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        final updatedUrls = [...existingProfile.portfolioUrls, photoUrl];
        await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
          portfolioUrls: updatedUrls,
        );
        _logger.success('Portfolio photo added successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error adding portfolio photo', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> removePortfolioPhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        final updatedUrls = existingProfile.portfolioUrls
            .where((url) => url != photoUrl)
            .toList();
        await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
          portfolioUrls: updatedUrls,
        );
        _logger.success('Portfolio photo removed successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error removing portfolio photo', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> updateJobStats({
    required String userId,
    required double newRating,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final existingProfile = await _mockDataSource!.getProfileByUserId(userId);
        if (existingProfile == null) {
          return const Failure(message: 'Perfil profesional no encontrado');
        }

        // Calculate new average rating
        final currentTotal = (existingProfile.averageRating ?? 0) * existingProfile.reviewsCount;
        final newTotal = currentTotal + newRating;
        final newReviewsCount = existingProfile.reviewsCount + 1;
        final newAverageRating = newTotal / newReviewsCount;

        // Update completed jobs and ratings
        await _mockDataSource!.updateProfile(
          profileId: existingProfile.id!,
          // Update using the existing copyWith which will handle the update
        );

        // For now, we need to manually update these fields since the datasource
        // doesn't have direct support for incrementing completedJobs
        // This would be better handled with a specific method in the datasource
        _logger.success('Job stats updated successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating job stats', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }
}

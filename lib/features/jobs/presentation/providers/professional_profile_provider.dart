import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/professional_profile_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del perfil profesional
class ProfessionalProfileState {
  final ProfessionalProfileEntity? profile;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  const ProfessionalProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  });

  ProfessionalProfileState copyWith({
    ProfessionalProfileEntity? profile,
    bool? isLoading,
    String? error,
    bool? isEditing,
    bool clearError = false,
  }) {
    return ProfessionalProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

/// Notifier para gestionar perfil profesional
class ProfessionalProfileNotifier extends StateNotifier<ProfessionalProfileState> {
  final ProfessionalProfileRepository _repository;
  final String _userId;

  ProfessionalProfileNotifier(this._repository, this._userId)
      : super(const ProfessionalProfileState()) {
    loadProfile();
  }

  /// Cargar perfil profesional
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getProfessionalProfile(_userId);

    if (result is Success<ProfessionalProfileEntity>) {
      state = state.copyWith(
        profile: result.data,
        isLoading: false,
      );
    } else if (result is Failure<ProfessionalProfileEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualizar (pull to refresh)
  Future<void> refresh() => loadProfile();

  /// Activar modo edición
  void startEditing() {
    state = state.copyWith(isEditing: true);
  }

  /// Cancelar modo edición
  void cancelEditing() {
    state = state.copyWith(isEditing: false);
  }

  /// Actualizar perfil
  Future<bool> updateProfile({
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
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.updateProfessionalProfile(
      userId: _userId,
      specialties: specialties,
      trades: trades,
      experienceYears: experienceYears,
      availability: availability,
      preferredLocations: preferredLocations,
      hasOwnTools: hasOwnTools,
      certifications: certifications,
      portfolioUrls: portfolioUrls,
      hourlyRate: hourlyRate,
      dailyRate: dailyRate,
      lookingForWork: lookingForWork,
      bio: bio,
    );

    if (result is Success<ProfessionalProfileEntity>) {
      state = state.copyWith(
        profile: result.data,
        isLoading: false,
        isEditing: false,
      );
      return true;
    } else if (result is Failure<ProfessionalProfileEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    return false;
  }

  /// Actualizar disponibilidad rápidamente
  Future<void> updateAvailability(AvailabilityStatus availability) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.updateAvailability(
      userId: _userId,
      availability: availability,
    );

    if (result is Success<void>) {
      // Recargar perfil
      await loadProfile();
    } else if (result is Failure<void>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualizar si está buscando trabajo
  Future<void> updateLookingForWork(bool lookingForWork) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.updateLookingForWork(
      userId: _userId,
      lookingForWork: lookingForWork,
    );

    if (result is Success<void>) {
      // Recargar perfil
      await loadProfile();
    } else if (result is Failure<void>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }
}

/// Provider del perfil profesional por userId
final professionalProfileProvider = StateNotifierProvider.family
    .autoDispose<ProfessionalProfileNotifier, ProfessionalProfileState, String>(
  (ref, userId) {
    final repository = ref.watch(professionalProfileRepositoryProvider);
    return ProfessionalProfileNotifier(repository, userId);
  },
);

/// Provider del perfil del usuario actual autenticado
final currentProfessionalProfileProvider =
    StateNotifierProvider.autoDispose<ProfessionalProfileNotifier,
        ProfessionalProfileState>(
  (ref) {
    final authState = ref.watch(authNotifierProvider);
    if (authState is! Authenticated) {
      throw Exception('Usuario no autenticado');
    }

    final repository = ref.watch(professionalProfileRepositoryProvider);
    return ProfessionalProfileNotifier(repository, authState.user.id);
  },
);

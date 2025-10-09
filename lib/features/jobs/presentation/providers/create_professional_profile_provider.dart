import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/professional_profile_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del formulario de creación/edición de perfil profesional
class CreateProfessionalProfileState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final ProfessionalProfileEntity? createdProfile;
  final bool isEditMode;

  const CreateProfessionalProfileState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.createdProfile,
    this.isEditMode = false,
  });

  CreateProfessionalProfileState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    ProfessionalProfileEntity? createdProfile,
    bool? isEditMode,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return CreateProfessionalProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      createdProfile: createdProfile ?? this.createdProfile,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}

/// Notifier para crear/actualizar perfil profesional
class CreateProfessionalProfileNotifier extends StateNotifier<CreateProfessionalProfileState> {
  final ProfessionalProfileRepository _repository;
  final Ref _ref;

  CreateProfessionalProfileNotifier(this._repository, this._ref)
      : super(const CreateProfessionalProfileState());

  /// Crear perfil profesional
  Future<bool> createProfile({
    required List<String> specialties,
    required List<Trade> trades,
    required int experienceYears,
    List<String>? preferredLocations,
    bool? hasOwnTools,
    List<String>? certifications,
    double? hourlyRate,
    double? dailyRate,
    String? bio,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );

    // Obtener el usuario actual
    final authState = _ref.read(authNotifierProvider);
    if (authState is! Authenticated) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes iniciar sesión para crear un perfil',
      );
      return false;
    }

    final userId = authState.user.id;

    // Validaciones
    if (trades.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes seleccionar al menos un oficio',
      );
      return false;
    }

    if (experienceYears < 0) {
      state = state.copyWith(
        isLoading: false,
        error: 'Los años de experiencia deben ser un número positivo',
      );
      return false;
    }

    final result = await _repository.createProfessionalProfile(
      userId: userId,
      specialties: specialties,
      trades: trades,
      experienceYears: experienceYears,
      preferredLocations: preferredLocations,
      hasOwnTools: hasOwnTools,
      certifications: certifications,
      hourlyRate: hourlyRate,
      dailyRate: dailyRate,
      bio: bio,
    );

    if (result is Success<ProfessionalProfileEntity>) {
      state = state.copyWith(
        isLoading: false,
        createdProfile: result.data,
        successMessage: 'Perfil profesional creado exitosamente',
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

  /// Actualizar perfil profesional existente
  Future<bool> updateProfile({
    required List<String> specialties,
    required List<Trade> trades,
    required int experienceYears,
    AvailabilityStatus? availability,
    List<String>? preferredLocations,
    bool? hasOwnTools,
    List<String>? certifications,
    double? hourlyRate,
    double? dailyRate,
    bool? lookingForWork,
    String? bio,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );

    // Obtener el usuario actual
    final authState = _ref.read(authNotifierProvider);
    if (authState is! Authenticated) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes iniciar sesión para actualizar tu perfil',
      );
      return false;
    }

    final userId = authState.user.id;

    // Validaciones
    if (trades.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes seleccionar al menos un oficio',
      );
      return false;
    }

    final result = await _repository.updateProfessionalProfile(
      userId: userId,
      specialties: specialties,
      trades: trades,
      experienceYears: experienceYears,
      availability: availability,
      preferredLocations: preferredLocations,
      hasOwnTools: hasOwnTools,
      certifications: certifications,
      hourlyRate: hourlyRate,
      dailyRate: dailyRate,
      lookingForWork: lookingForWork,
      bio: bio,
    );

    if (result is Success<ProfessionalProfileEntity>) {
      state = state.copyWith(
        isLoading: false,
        createdProfile: result.data,
        successMessage: 'Perfil profesional actualizado exitosamente',
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

  /// Limpiar mensajes
  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  /// Resetear estado
  void reset() {
    state = const CreateProfessionalProfileState();
  }

  /// Activar modo edición
  void setEditMode(bool isEdit) {
    state = state.copyWith(isEditMode: isEdit);
  }
}

/// Provider del notifier
final createProfessionalProfileProvider = StateNotifierProvider.autoDispose<
    CreateProfessionalProfileNotifier, CreateProfessionalProfileState>(
  (ref) {
    final repository = ref.watch(professionalProfileRepositoryProvider);
    return CreateProfessionalProfileNotifier(repository, ref);
  },
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del formulario de creación de oferta
class CreateJobPostState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final JobPostEntity? createdJob;

  const CreateJobPostState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.createdJob,
  });

  CreateJobPostState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    JobPostEntity? createdJob,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return CreateJobPostState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      createdJob: createdJob ?? this.createdJob,
    );
  }
}

/// Notifier para crear ofertas de trabajo
class CreateJobPostNotifier extends StateNotifier<CreateJobPostState> {
  final JobRepository _repository;
  final Ref _ref;

  CreateJobPostNotifier(this._repository, this._ref)
      : super(const CreateJobPostState());

  /// Crear nueva oferta de trabajo
  Future<bool> createJobPost({
    required List<String> categoryIds,
    required String title,
    required String description,
    required String location,
    required JobType type,
    int? durationDays,
    required PaymentType paymentType,
    double? budgetMin,
    double? budgetMax,
    required UrgencyLevel urgency,
    int? requiredWorkers,
    List<String>? requirements,
    int? expiresInDays,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );

    // Obtener el cliente actual
    final authState = _ref.read(authNotifierProvider);
    if (authState is! Authenticated) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes iniciar sesión para publicar una oferta',
      );
      return false;
    }

    final clientId = authState.user.id;

    // Validaciones básicas
    if (categoryIds.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes seleccionar al menos una categoría',
      );
      return false;
    }

    if (title.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'El título es obligatorio',
      );
      return false;
    }

    if (description.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'La descripción es obligatoria',
      );
      return false;
    }

    if (location.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'La ubicación es obligatoria',
      );
      return false;
    }

    // Validar presupuesto
    if (budgetMin != null && budgetMax != null && budgetMin > budgetMax) {
      state = state.copyWith(
        isLoading: false,
        error: 'El presupuesto mínimo no puede ser mayor al máximo',
      );
      return false;
    }

    final result = await _repository.createJobPost(
      clientId: clientId,
      categoryIds: categoryIds,
      title: title.trim(),
      description: description.trim(),
      location: location.trim(),
      type: type,
      durationDays: durationDays,
      paymentType: paymentType,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      urgency: urgency,
      requiredWorkers: requiredWorkers ?? 1,
      requirements: requirements?.where((r) => r.trim().isNotEmpty).toList(),
      expiresInDays: expiresInDays ?? 30,
    );

    if (result is Success<JobPostEntity>) {
      state = state.copyWith(
        isLoading: false,
        createdJob: result.data,
        successMessage: 'Oferta publicada exitosamente',
      );
      return true;
    } else if (result is Failure<JobPostEntity>) {
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
    state = const CreateJobPostState();
  }
}

/// Provider del notifier
final createJobPostProvider =
    StateNotifierProvider.autoDispose<CreateJobPostNotifier, CreateJobPostState>(
  (ref) {
    final repository = ref.watch(jobRepositoryProvider);
    return CreateJobPostNotifier(repository, ref);
  },
);

/// Categorías disponibles (temporal - hardcoded)
class JobCategory {
  final String id;
  final String name;
  final String icon;

  const JobCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

final jobCategoriesProvider = Provider<List<JobCategory>>((ref) {
  return const [
    JobCategory(id: '1', name: 'Construcción/Albañilería', icon: '🏗️'),
    JobCategory(id: '2', name: 'Electricidad', icon: '⚡'),
    JobCategory(id: '3', name: 'Plomería', icon: '🔧'),
    JobCategory(id: '4', name: 'Carpintería', icon: '🪚'),
    JobCategory(id: '5', name: 'Pintura', icon: '🎨'),
    JobCategory(id: '6', name: 'Jardinería', icon: '🌿'),
  ];
});

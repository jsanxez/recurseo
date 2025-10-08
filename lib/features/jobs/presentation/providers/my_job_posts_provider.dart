import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado de las ofertas de trabajo del cliente
class MyJobPostsState {
  final List<JobPostEntity> jobs;
  final bool isLoading;
  final String? error;
  final JobPostStatus? filterStatus;

  const MyJobPostsState({
    this.jobs = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  MyJobPostsState copyWith({
    List<JobPostEntity>? jobs,
    bool? isLoading,
    String? error,
    JobPostStatus? filterStatus,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return MyJobPostsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
    );
  }
}

/// Notifier para gestionar las ofertas de trabajo del cliente
class MyJobPostsNotifier extends StateNotifier<MyJobPostsState> {
  final JobRepository _repository;
  final Ref _ref;

  MyJobPostsNotifier(this._repository, this._ref)
      : super(const MyJobPostsState()) {
    loadJobs();
  }

  /// Cargar ofertas del cliente actual
  Future<void> loadJobs() async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Obtener el usuario actual
    final authState = _ref.read(authNotifierProvider);
    if (authState is! Authenticated) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes iniciar sesión para ver tus ofertas',
      );
      return;
    }

    final clientId = authState.user.id;

    final result = await _repository.getClientJobPosts(clientId);

    if (result is Success<List<JobPostEntity>>) {
      // Filtrar por estado si hay filtro activo
      var filteredJobs = result.data;
      if (state.filterStatus != null) {
        filteredJobs = result.data
            .where((j) => j.status == state.filterStatus)
            .toList();
      }

      state = state.copyWith(
        jobs: filteredJobs,
        isLoading: false,
      );
    } else if (result is Failure<List<JobPostEntity>>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualizar (pull to refresh)
  Future<void> refresh() => loadJobs();

  /// Filtrar por estado
  void filterByStatus(JobPostStatus? status) {
    state = state.copyWith(filterStatus: status);
    loadJobs();
  }

  /// Limpiar filtros
  void clearFilters() {
    state = state.copyWith(clearFilter: true);
    loadJobs();
  }

  /// Cerrar una oferta de trabajo
  Future<void> closeJob(String jobId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.updateJobPostStatus(
      jobPostId: jobId,
      status: JobPostStatus.closed,
    );

    if (result is Success<JobPostEntity>) {
      // Actualizar la lista
      await loadJobs();
    } else if (result is Failure<JobPostEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Cancelar una oferta de trabajo
  Future<void> cancelJob(String jobId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.updateJobPostStatus(
      jobPostId: jobId,
      status: JobPostStatus.cancelled,
    );

    if (result is Success<JobPostEntity>) {
      // Actualizar la lista
      await loadJobs();
    } else if (result is Failure<JobPostEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }
}

/// Provider del notifier
final myJobPostsProvider =
    StateNotifierProvider.autoDispose<MyJobPostsNotifier, MyJobPostsState>(
  (ref) {
    final repository = ref.watch(jobRepositoryProvider);
    return MyJobPostsNotifier(repository, ref);
  },
);

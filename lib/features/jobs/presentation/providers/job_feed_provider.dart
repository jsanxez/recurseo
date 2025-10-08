import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del feed de trabajos
class JobFeedState {
  final List<JobPostEntity> jobs;
  final bool isLoading;
  final String? error;
  final JobSearchFilters? filters;
  final JobSortOption sortBy;

  const JobFeedState({
    this.jobs = const [],
    this.isLoading = false,
    this.error,
    this.filters,
    this.sortBy = JobSortOption.recent,
  });

  JobFeedState copyWith({
    List<JobPostEntity>? jobs,
    bool? isLoading,
    String? error,
    JobSearchFilters? filters,
    JobSortOption? sortBy,
  }) {
    return JobFeedState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// Notifier para el feed de trabajos
class JobFeedNotifier extends StateNotifier<JobFeedState> {
  final JobRepository _repository;

  JobFeedNotifier(this._repository) : super(const JobFeedState()) {
    loadJobs();
  }

  /// Cargar trabajos con filtros y ordenamiento actuales
  Future<void> loadJobs() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getJobPosts(
      filters: state.filters,
      sortBy: state.sortBy,
    );

    if (result is Success<List<JobPostEntity>>) {
      state = state.copyWith(
        jobs: result.data,
        isLoading: false,
      );
    } else if (result is Failure<List<JobPostEntity>>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Aplicar filtros
  void applyFilters(JobSearchFilters filters) {
    state = state.copyWith(filters: filters);
    loadJobs();
  }

  /// Limpiar filtros
  void clearFilters() {
    state = state.copyWith(filters: null);
    loadJobs();
  }

  /// Cambiar ordenamiento
  void setSortOption(JobSortOption sortBy) {
    state = state.copyWith(sortBy: sortBy);
    loadJobs();
  }

  /// Refrescar
  Future<void> refresh() => loadJobs();
}

/// Provider del notifier
final jobFeedProvider =
    StateNotifierProvider<JobFeedNotifier, JobFeedState>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return JobFeedNotifier(repository);
});

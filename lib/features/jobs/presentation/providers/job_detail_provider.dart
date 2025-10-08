import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del detalle de trabajo
class JobDetailState {
  final JobPostEntity? job;
  final bool isLoading;
  final String? error;

  const JobDetailState({
    this.job,
    this.isLoading = false,
    this.error,
  });

  JobDetailState copyWith({
    JobPostEntity? job,
    bool? isLoading,
    String? error,
  }) {
    return JobDetailState(
      job: job ?? this.job,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier para el detalle de un trabajo
class JobDetailNotifier extends StateNotifier<JobDetailState> {
  final JobRepository _repository;
  final String jobId;

  JobDetailNotifier(this._repository, this.jobId)
      : super(const JobDetailState()) {
    loadJob();
  }

  /// Cargar detalle del trabajo
  Future<void> loadJob() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getJobPost(jobId);

    if (result is Success<JobPostEntity>) {
      state = state.copyWith(
        job: result.data,
        isLoading: false,
      );
    } else if (result is Failure<JobPostEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Refrescar
  Future<void> refresh() => loadJob();
}

/// Provider del notifier (family para pasar el jobId)
final jobDetailProvider = StateNotifierProvider.family<JobDetailNotifier,
    JobDetailState, String>((ref, jobId) {
  final repository = ref.watch(jobRepositoryProvider);
  return JobDetailNotifier(repository, jobId);
});

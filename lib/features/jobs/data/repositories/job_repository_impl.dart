import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/data/datasources/job_mock_datasource.dart';
import 'package:recurseo/features/jobs/data/models/job_post_model.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';

/// Implementación del repositorio de ofertas de trabajo
class JobRepositoryImpl implements JobRepository {
  final JobMockDataSource? _mockDataSource;
  // final JobRemoteDataSource? _remoteDataSource; // Para futuro uso con API
  final _logger = const Logger('JobRepositoryImpl');

  JobRepositoryImpl({
    JobMockDataSource? mockDataSource,
    // JobRemoteDataSource? remoteDataSource,
  }) : _mockDataSource = mockDataSource {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for jobs');
    } else {
      _logger.info('🌐 Using REMOTE API for jobs');
    }
  }

  @override
  Future<Result<List<JobPostEntity>>> getJobPosts({
    JobSearchFilters? filters,
    JobSortOption? sortBy,
    int? limit,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final jobs = await _mockDataSource!.getJobPosts(
          filters: filters,
          sortBy: sortBy,
          limit: limit,
        );
        return Success(jobs);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting job posts', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<JobPostEntity>> getJobPost(String jobPostId) async {
    try {
      if (AppConfig.useMockData) {
        final job = await _mockDataSource!.getJobPost(jobPostId);
        return Success(job);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting job post by id', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<JobPostEntity>>> getClientJobPosts(
    String clientId,
  ) async {
    try {
      if (AppConfig.useMockData) {
        final jobs = await _mockDataSource!.getClientJobPosts(clientId);
        return Success(jobs);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting job posts by client', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<JobPostEntity>> createJobPost({
    required String clientId,
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
    List<String>? photoUrls,
    int? expiresInDays,
  }) async {
    try {
      if (AppConfig.useMockData) {
        // Create a JobPostModel to pass to the datasource
        final jobPost = JobPostModel(
          id: '', // Will be assigned by datasource
          clientId: clientId,
          categoryIds: categoryIds,
          title: title,
          description: description,
          location: location,
          type: type,
          durationDays: durationDays,
          paymentType: paymentType,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          urgency: urgency,
          requiredWorkers: requiredWorkers ?? 1,
          requirements: requirements ?? [],
          photoUrls: photoUrls ?? [],
          status: JobPostStatus.open,
          createdAt: DateTime.now(),
          expiresAt: expiresInDays != null
              ? DateTime.now().add(Duration(days: expiresInDays))
              : DateTime.now().add(const Duration(days: 30)),
          proposalsCount: 0,
        );
        final job = await _mockDataSource!.createJobPost(jobPost);
        _logger.success('Job post created successfully');
        return Success(job);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error creating job post', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<JobPostEntity>> updateJobPost({
    required String jobPostId,
    String? title,
    String? description,
    String? location,
    JobType? type,
    int? durationDays,
    PaymentType? paymentType,
    double? budgetMin,
    double? budgetMax,
    UrgencyLevel? urgency,
    int? requiredWorkers,
    List<String>? requirements,
    List<String>? photoUrls,
  }) async {
    try {
      if (AppConfig.useMockData) {
        // Get the existing job post first
        final existingJob = await _mockDataSource!.getJobPost(jobPostId);

        // Create updated job post with new values
        final updatedJob = existingJob.copyWith(
          title: title,
          description: description,
          location: location,
          type: type,
          durationDays: durationDays,
          paymentType: paymentType,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          urgency: urgency,
          requiredWorkers: requiredWorkers,
          requirements: requirements,
          photoUrls: photoUrls,
        );

        final job = await _mockDataSource.updateJobPost(updatedJob);
        _logger.success('Job post updated successfully');
        return Success(job);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating job post', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<JobPostEntity>> updateJobPostStatus({
    required String jobPostId,
    required JobPostStatus status,
  }) async {
    try {
      if (AppConfig.useMockData) {
        // Get the existing job post
        final existingJob = await _mockDataSource!.getJobPost(jobPostId);

        // Update with new status
        final updatedJob = existingJob.copyWith(status: status);
        final job = await _mockDataSource.updateJobPost(updatedJob);

        _logger.success('Job post status updated successfully');
        return Success(job);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating job post status', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> closeJobPost(String jobPostId) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.closeJobPost(jobPostId);
        _logger.success('Job post closed successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error closing job post', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> cancelJobPost(String jobPostId) async {
    try {
      if (AppConfig.useMockData) {
        // Get the existing job post
        final existingJob = await _mockDataSource!.getJobPost(jobPostId);

        // Update with cancelled status
        final updatedJob = existingJob.copyWith(status: JobPostStatus.closed);
        await _mockDataSource.updateJobPost(updatedJob);

        _logger.success('Job post cancelled successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error cancelling job post', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> markJobPostFilled(String jobPostId) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.markJobPostFilled(jobPostId);
        _logger.success('Job post marked as filled successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error marking job post as filled', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> incrementProposalsCount(String jobPostId) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.incrementProposalsCount(jobPostId);
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error incrementing proposals count', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ClientJobStats>> getClientJobStats(String clientId) async {
    try {
      if (AppConfig.useMockData) {
        final stats = await _mockDataSource!.getClientJobStats(clientId);
        return Success(stats);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting client job stats', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }
}

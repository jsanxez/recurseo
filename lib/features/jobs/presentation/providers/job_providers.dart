import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/features/jobs/data/datasources/job_mock_datasource.dart';
import 'package:recurseo/features/jobs/data/datasources/professional_profile_mock_datasource.dart';
import 'package:recurseo/features/jobs/data/datasources/proposal_mock_datasource.dart';
import 'package:recurseo/features/jobs/data/repositories/job_repository_impl.dart';
import 'package:recurseo/features/jobs/data/repositories/professional_profile_repository_impl.dart';
import 'package:recurseo/features/jobs/data/repositories/proposal_repository_impl.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';
import 'package:recurseo/features/jobs/domain/repositories/professional_profile_repository.dart';
import 'package:recurseo/features/jobs/domain/repositories/proposal_repository.dart';

/// ==================== Data Sources ====================

/// Provider del mock datasource de trabajos
final jobMockDataSourceProvider = Provider<JobMockDataSource>((ref) {
  return JobMockDataSource();
});

/// Provider del mock datasource de propuestas
final proposalMockDataSourceProvider = Provider<ProposalMockDataSource>((ref) {
  return ProposalMockDataSource();
});

/// Provider del mock datasource de perfiles profesionales
final professionalProfileMockDataSourceProvider =
    Provider<ProfessionalProfileMockDataSource>((ref) {
  return ProfessionalProfileMockDataSource();
});

/// ==================== Repositories ====================

/// Provider del repositorio de trabajos
final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final mockDataSource = ref.watch(jobMockDataSourceProvider);
  return JobRepositoryImpl(mockDataSource: mockDataSource);
});

/// Provider del repositorio de propuestas
final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  final mockDataSource = ref.watch(proposalMockDataSourceProvider);
  return ProposalRepositoryImpl(mockDataSource: mockDataSource);
});

/// Provider del repositorio de perfiles profesionales
final professionalProfileRepositoryProvider =
    Provider<ProfessionalProfileRepository>((ref) {
  final mockDataSource = ref.watch(professionalProfileMockDataSourceProvider);
  return ProfessionalProfileRepositoryImpl(mockDataSource: mockDataSource);
});

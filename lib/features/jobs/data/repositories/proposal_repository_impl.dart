import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/data/datasources/proposal_mock_datasource.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/proposal_repository.dart';

/// Implementación del repositorio de propuestas
class ProposalRepositoryImpl implements ProposalRepository {
  final ProposalMockDataSource? _mockDataSource;
  // final ProposalRemoteDataSource? _remoteDataSource; // Para futuro uso con API
  final _logger = const Logger('ProposalRepositoryImpl');

  ProposalRepositoryImpl({
    ProposalMockDataSource? mockDataSource,
    // ProposalRemoteDataSource? remoteDataSource,
  }) : _mockDataSource = mockDataSource {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for proposals');
    } else {
      _logger.info('🌐 Using REMOTE API for proposals');
    }
  }

  @override
  Future<Result<List<ProposalEntity>>> getJobPostProposals(
    String jobPostId,
  ) async {
    try {
      if (AppConfig.useMockData) {
        final proposals = await _mockDataSource!.getProposalsByJobPost(jobPostId);
        return Success(proposals);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting proposals by job post', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ProposalEntity>>> getProfessionalProposals(
    String professionalId,
  ) async {
    try {
      if (AppConfig.useMockData) {
        final proposals = await _mockDataSource!.getProposalsByProfessional(
          professionalId,
        );
        return Success(proposals);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting proposals by professional', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProposalEntity>> getProposal(String proposalId) async {
    try {
      if (AppConfig.useMockData) {
        final proposal = await _mockDataSource!.getProposalById(proposalId);
        return Success(proposal);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting proposal by id', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProposalEntity>> createProposal({
    required String jobPostId,
    required String professionalId,
    required String message,
    required double proposedRate,
    required String rateType,
    required DateTime availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
  }) async {
    try {
      if (AppConfig.useMockData) {
        // For mock, we need to get professional name - in real implementation
        // this would come from the auth context
        final proposal = await _mockDataSource!.createProposal(
          jobPostId: jobPostId,
          professionalId: professionalId,
          professionalName: 'Professional User', // TODO: Get from auth context
          message: message,
          proposedRate: proposedRate,
          rateType: rateType,
          availableFrom: availableFrom,
          estimatedDays: estimatedDays,
          portfolioUrls: portfolioUrls,
        );
        _logger.success('Proposal created successfully');
        return Success(proposal);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error creating proposal', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProposalEntity>> updateProposal({
    required String proposalId,
    String? message,
    double? proposedRate,
    DateTime? availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final proposal = await _mockDataSource!.updateProposal(
          proposalId: proposalId,
          message: message,
          proposedRate: proposedRate,
          availableFrom: availableFrom,
          portfolioUrls: portfolioUrls,
          // Note: estimatedDuration is not in the datasource updateProposal method
        );
        _logger.success('Proposal updated successfully');
        return Success(proposal);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error updating proposal', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> withdrawProposal(String proposalId) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.withdrawProposal(proposalId);
        _logger.success('Proposal withdrawn successfully');
        return const Success(null);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error withdrawing proposal', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProposalEntity>> acceptProposal(String proposalId) async {
    try {
      if (AppConfig.useMockData) {
        final proposal = await _mockDataSource!.acceptProposal(proposalId);
        _logger.success('Proposal accepted successfully');
        return Success(proposal);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error accepting proposal', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProposalEntity>> rejectProposal({
    required String proposalId,
    String? reason,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final proposal = await _mockDataSource!.rejectProposal(
          proposalId,
          rejectionReason: reason,
        );
        _logger.success('Proposal rejected successfully');
        return Success(proposal);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error rejecting proposal', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<bool>> hasProfessionalProposed({
    required String professionalId,
    required String jobPostId,
  }) async {
    try {
      if (AppConfig.useMockData) {
        final proposals = await _mockDataSource!.getProposalsByProfessional(
          professionalId,
        );
        final hasProposed = proposals.any(
          (p) => p.jobPostId == jobPostId && p.status != ProposalStatus.withdrawn,
        );
        return Success(hasProposed);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error checking if professional has proposed', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProfessionalProposalStats>> getProfessionalProposalStats(
    String professionalId,
  ) async {
    try {
      if (AppConfig.useMockData) {
        final stats = await _mockDataSource!.getProfessionalProposalStats(
          professionalId,
        );

        final totalProposals = stats['total'] ?? 0;
        final acceptedProposals = stats['accepted'] ?? 0;
        final acceptanceRate = totalProposals > 0
            ? (acceptedProposals / totalProposals) * 100
            : 0.0;

        final proposalStats = ProfessionalProposalStats(
          totalProposals: totalProposals,
          pendingProposals: stats['pending'] ?? 0,
          acceptedProposals: acceptedProposals,
          rejectedProposals: stats['rejected'] ?? 0,
          acceptanceRate: acceptanceRate,
        );

        return Success(proposalStats);
      } else {
        // TODO: Implementar llamada a API remota
        return const Failure(message: 'API remota no implementada aún');
      }
    } catch (e, st) {
      _logger.error('Error getting proposal stats', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }
}

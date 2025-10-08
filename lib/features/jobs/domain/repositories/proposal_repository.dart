import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';

/// Repositorio de propuestas
abstract class ProposalRepository {
  /// Obtener propuestas para una oferta específica
  Future<Result<List<ProposalEntity>>> getJobPostProposals(String jobPostId);

  /// Obtener propuestas enviadas por un profesional
  Future<Result<List<ProposalEntity>>> getProfessionalProposals(
    String professionalId,
  );

  /// Obtener una propuesta específica por ID
  Future<Result<ProposalEntity>> getProposal(String proposalId);

  /// Crear/enviar una nueva propuesta
  Future<Result<ProposalEntity>> createProposal({
    required String jobPostId,
    required String professionalId,
    required String message,
    required double proposedRate,
    required String rateType,
    required DateTime availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
  });

  /// Actualizar una propuesta existente (solo si está pendiente)
  Future<Result<ProposalEntity>> updateProposal({
    required String proposalId,
    String? message,
    double? proposedRate,
    DateTime? availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
  });

  /// Aceptar una propuesta (cliente)
  Future<Result<ProposalEntity>> acceptProposal(String proposalId);

  /// Rechazar una propuesta (cliente)
  Future<Result<ProposalEntity>> rejectProposal({
    required String proposalId,
    String? reason,
  });

  /// Retirar una propuesta (profesional)
  Future<Result<void>> withdrawProposal(String proposalId);

  /// Verificar si un profesional ya envió propuesta a una oferta
  Future<Result<bool>> hasProfessionalProposed({
    required String professionalId,
    required String jobPostId,
  });

  /// Obtener estadísticas de propuestas del profesional
  Future<Result<ProfessionalProposalStats>> getProfessionalProposalStats(
    String professionalId,
  );
}

/// Estadísticas de propuestas del profesional
class ProfessionalProposalStats {
  final int totalProposals;
  final int pendingProposals;
  final int acceptedProposals;
  final int rejectedProposals;
  final double acceptanceRate; // Porcentaje de propuestas aceptadas

  const ProfessionalProposalStats({
    required this.totalProposals,
    required this.pendingProposals,
    required this.acceptedProposals,
    required this.rejectedProposals,
    required this.acceptanceRate,
  });
}

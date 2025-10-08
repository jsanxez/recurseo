import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/jobs/data/models/proposal_model.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';

/// DataSource mock para propuestas (datos de prueba)
class ProposalMockDataSource {
  final _logger = const Logger('ProposalMockDataSource');

  // Propuestas de prueba
  static final _mockProposals = <ProposalModel>[
    // Propuestas para "Electricista Urgente para Instalación Residencial" (job_1)
    ProposalModel(
      id: 'prop_1',
      jobPostId: 'job_1',
      professionalId: '2', // María González (profesional@test.com)
      professionalName: 'María González',
      message: 'Tengo 8 años de experiencia en instalaciones eléctricas residenciales. Cuento con licencia profesional vigente y herramientas completas. Puedo empezar mañana mismo.',
      proposedRate: 50.0,
      rateType: 'por_hora',
      availableFrom: DateTime.now().add(const Duration(days: 1)),
      portfolioUrls: [
        'https://example.com/portfolio/electrical-1.jpg',
        'https://example.com/portfolio/electrical-2.jpg',
      ],
      yearsExperience: 8,
      estimatedDuration: '3 días',
      status: ProposalStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    // Propuestas para "Se Necesitan 3 Albañiles para Obra en Tumbaco" (job_2)
    ProposalModel(
      id: 'prop_2',
      jobPostId: 'job_2',
      professionalId: '2',
      professionalName: 'María González',
      message: 'Somos un equipo de 3 albañiles con experiencia en construcción de viviendas. Tenemos referencias verificables de proyectos anteriores en Tumbaco.',
      proposedRate: 40.0,
      rateType: 'por_dia',
      availableFrom: DateTime.now().add(const Duration(days: 2)),
      portfolioUrls: [
        'https://example.com/portfolio/masonry-1.jpg',
      ],
      yearsExperience: 5,
      estimatedDuration: '2 meses',
      status: ProposalStatus.accepted,
      acceptedAt: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // Propuesta para "Pintor con Experiencia para Casa de 200m2" (job_3)
    ProposalModel(
      id: 'prop_3',
      jobPostId: 'job_3',
      professionalId: '2',
      professionalName: 'María González',
      message: 'Soy pintor profesional con 10 años de experiencia. Trabajo con pinturas de primera calidad y garantizo un acabado perfecto. Incluyo preparación de superficies.',
      proposedRate: 2800.0,
      rateType: 'por_proyecto',
      availableFrom: DateTime.now().add(const Duration(days: 3)),
      portfolioUrls: [
        'https://example.com/portfolio/painting-1.jpg',
        'https://example.com/portfolio/painting-2.jpg',
        'https://example.com/portfolio/painting-3.jpg',
      ],
      yearsExperience: 10,
      estimatedDuration: '10 días',
      status: ProposalStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),

    // Propuesta rechazada para ejemplo
    ProposalModel(
      id: 'prop_4',
      jobPostId: 'job_1',
      professionalId: '4', // Otro profesional
      professionalName: 'Juan Pérez',
      message: 'Puedo hacer el trabajo.',
      proposedRate: 80.0,
      rateType: 'por_hora',
      availableFrom: DateTime.now().add(const Duration(days: 7)),
      portfolioUrls: [],
      yearsExperience: 2,
      status: ProposalStatus.rejected,
      rejectedAt: DateTime.now().subtract(const Duration(hours: 1)),
      rejectionReason: 'Tarifa muy alta para el trabajo solicitado',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // Propuesta retirada
    ProposalModel(
      id: 'prop_5',
      jobPostId: 'job_3',
      professionalId: '5',
      professionalName: 'Pedro López',
      message: 'Disponible para el proyecto de pintura.',
      proposedRate: 2500.0,
      rateType: 'por_proyecto',
      availableFrom: DateTime.now().add(const Duration(days: 1)),
      portfolioUrls: [],
      yearsExperience: 3,
      estimatedDuration: '12 días',
      status: ProposalStatus.withdrawn,
      withdrawnAt: DateTime.now().subtract(const Duration(hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  /// Obtener propuestas por ID de oferta de trabajo
  Future<List<ProposalModel>> getProposalsByJobPost(String jobPostId) async {
    _logger.info('Mock: Getting proposals for job post $jobPostId');
    await Future.delayed(const Duration(milliseconds: 400));

    final proposals = _mockProposals
        .where((p) => p.jobPostId == jobPostId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _logger.success('Mock: Found ${proposals.length} proposals');
    return proposals;
  }

  /// Obtener propuestas por ID de profesional
  Future<List<ProposalModel>> getProposalsByProfessional(
    String professionalId,
  ) async {
    _logger.info('Mock: Getting proposals by professional $professionalId');
    await Future.delayed(const Duration(milliseconds: 400));

    final proposals = _mockProposals
        .where((p) => p.professionalId == professionalId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _logger.success('Mock: Found ${proposals.length} proposals');
    return proposals;
  }

  /// Obtener propuesta por ID
  Future<ProposalModel> getProposalById(String proposalId) async {
    _logger.info('Mock: Getting proposal $proposalId');
    await Future.delayed(const Duration(milliseconds: 300));

    final proposal = _mockProposals.firstWhere(
      (p) => p.id == proposalId,
      orElse: () => throw Exception('Propuesta no encontrada'),
    );

    return proposal;
  }

  /// Crear nueva propuesta
  Future<ProposalModel> createProposal({
    required String jobPostId,
    required String professionalId,
    required String professionalName,
    required String message,
    required double proposedRate,
    required String rateType,
    required DateTime availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
    int? yearsExperience,
    String? estimatedDuration,
  }) async {
    _logger.info('Mock: Creating proposal for job $jobPostId');
    await Future.delayed(const Duration(milliseconds: 600));

    // Verificar si ya existe una propuesta del mismo profesional para esta oferta
    final existingProposal = _mockProposals.any(
      (p) =>
          p.jobPostId == jobPostId &&
          p.professionalId == professionalId &&
          p.status != ProposalStatus.withdrawn,
    );

    if (existingProposal) {
      throw Exception('Ya has enviado una propuesta para esta oferta');
    }

    final newProposal = ProposalModel(
      id: 'prop_${_mockProposals.length + 1}',
      jobPostId: jobPostId,
      professionalId: professionalId,
      professionalName: professionalName,
      message: message,
      proposedRate: proposedRate,
      rateType: rateType,
      availableFrom: availableFrom,
      estimatedDays: estimatedDays,
      portfolioUrls: portfolioUrls ?? [],
      yearsExperience: yearsExperience,
      estimatedDuration: estimatedDuration,
      status: ProposalStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockProposals.add(newProposal);
    _logger.success('Mock: Proposal created successfully');

    return newProposal;
  }

  /// Actualizar propuesta
  Future<ProposalModel> updateProposal({
    required String proposalId,
    String? message,
    double? proposedRate,
    DateTime? availableFrom,
    List<String>? portfolioUrls,
    String? estimatedDuration,
  }) async {
    _logger.info('Mock: Updating proposal $proposalId');
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProposals.indexWhere((p) => p.id == proposalId);

    if (index == -1) {
      throw Exception('Propuesta no encontrada');
    }

    final proposal = _mockProposals[index];

    // Solo se puede actualizar si está pendiente
    if (proposal.status != ProposalStatus.pending) {
      throw Exception('No se puede actualizar una propuesta ${proposal.status.name}');
    }

    final updatedProposal = proposal.copyWith(
      message: message,
      proposedRate: proposedRate,
      availableFrom: availableFrom,
      portfolioUrls: portfolioUrls,
      estimatedDuration: estimatedDuration,
      updatedAt: DateTime.now(),
    );

    _mockProposals[index] = updatedProposal;
    _logger.success('Mock: Proposal updated successfully');

    return updatedProposal;
  }

  /// Retirar propuesta (professional cancela su propuesta)
  Future<ProposalModel> withdrawProposal(String proposalId) async {
    _logger.info('Mock: Withdrawing proposal $proposalId');
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockProposals.indexWhere((p) => p.id == proposalId);

    if (index == -1) {
      throw Exception('Propuesta no encontrada');
    }

    final proposal = _mockProposals[index];

    // Solo se puede retirar si está pendiente
    if (proposal.status != ProposalStatus.pending) {
      throw Exception('No se puede retirar una propuesta ${proposal.status.name}');
    }

    final withdrawnProposal = proposal.copyWith(
      status: ProposalStatus.withdrawn,
      withdrawnAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockProposals[index] = withdrawnProposal;
    _logger.success('Mock: Proposal withdrawn successfully');

    return withdrawnProposal;
  }

  /// Aceptar propuesta (el cliente acepta la propuesta)
  Future<ProposalModel> acceptProposal(String proposalId) async {
    _logger.info('Mock: Accepting proposal $proposalId');
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProposals.indexWhere((p) => p.id == proposalId);

    if (index == -1) {
      throw Exception('Propuesta no encontrada');
    }

    final proposal = _mockProposals[index];

    // Solo se puede aceptar si está pendiente
    if (proposal.status != ProposalStatus.pending) {
      throw Exception('No se puede aceptar una propuesta ${proposal.status.name}');
    }

    final acceptedProposal = proposal.copyWith(
      status: ProposalStatus.accepted,
      acceptedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockProposals[index] = acceptedProposal;
    _logger.success('Mock: Proposal accepted successfully');

    return acceptedProposal;
  }

  /// Rechazar propuesta (el cliente rechaza la propuesta)
  Future<ProposalModel> rejectProposal(
    String proposalId, {
    String? rejectionReason,
  }) async {
    _logger.info('Mock: Rejecting proposal $proposalId');
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProposals.indexWhere((p) => p.id == proposalId);

    if (index == -1) {
      throw Exception('Propuesta no encontrada');
    }

    final proposal = _mockProposals[index];

    // Solo se puede rechazar si está pendiente
    if (proposal.status != ProposalStatus.pending) {
      throw Exception('No se puede rechazar una propuesta ${proposal.status.name}');
    }

    final rejectedProposal = proposal.copyWith(
      status: ProposalStatus.rejected,
      rejectedAt: DateTime.now(),
      rejectionReason: rejectionReason,
      updatedAt: DateTime.now(),
    );

    _mockProposals[index] = rejectedProposal;
    _logger.success('Mock: Proposal rejected successfully');

    return rejectedProposal;
  }

  /// Obtener estadísticas de propuestas para un profesional
  Future<Map<String, int>> getProfessionalProposalStats(
    String professionalId,
  ) async {
    _logger.info('Mock: Getting proposal stats for professional $professionalId');
    await Future.delayed(const Duration(milliseconds: 300));

    final proposals = _mockProposals
        .where((p) => p.professionalId == professionalId)
        .toList();

    final stats = {
      'total': proposals.length,
      'pending': proposals.where((p) => p.status == ProposalStatus.pending).length,
      'accepted': proposals.where((p) => p.status == ProposalStatus.accepted).length,
      'rejected': proposals.where((p) => p.status == ProposalStatus.rejected).length,
      'withdrawn': proposals.where((p) => p.status == ProposalStatus.withdrawn).length,
    };

    return stats;
  }
}

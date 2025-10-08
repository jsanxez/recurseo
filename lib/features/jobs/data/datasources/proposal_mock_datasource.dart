import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/jobs/data/models/proposal_model.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';

/// DataSource mock para propuestas (datos de prueba)
class ProposalMockDataSource {
  final _logger = const Logger('ProposalMockDataSource');

  // Propuestas de prueba
  static final _mockProposals = <ProposalModel>[
    // Propuestas para "Electricista Urgente para Instalación Residencial" (job_1, clientId: 1)
    ProposalModel(
      id: 'prop_1',
      jobPostId: '1', // Electricista Urgente - cliente@test.com
      jobTitle: 'Electricista Urgente para Instalación Residencial',
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
      estimatedDuration: '8 días',
      status: ProposalStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    ProposalModel(
      id: 'prop_2',
      jobPostId: '1', // Electricista Urgente - cliente@test.com
      jobTitle: 'Electricista Urgente para Instalación Residencial',
      professionalId: '4',
      professionalName: 'Carlos Rodríguez',
      message: 'Electricista certificado con 12 años de experiencia. He trabajado en más de 50 proyectos residenciales. Incluyo garantía de 2 años en mi trabajo.',
      proposedRate: 45.0,
      rateType: 'por_hora',
      availableFrom: DateTime.now(),
      portfolioUrls: [
        'https://example.com/portfolio/electrical-3.jpg',
      ],
      yearsExperience: 12,
      estimatedDuration: '7 días',
      status: ProposalStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),

    ProposalModel(
      id: 'prop_3',
      jobPostId: '1', // Electricista Urgente - cliente@test.com
      jobTitle: 'Electricista Urgente para Instalación Residencial',
      professionalId: '5',
      professionalName: 'Pedro López',
      message: 'Disponible de inmediato. Tengo experiencia en instalaciones completas y certificación vigente.',
      proposedRate: 60.0,
      rateType: 'por_hora',
      availableFrom: DateTime.now(),
      portfolioUrls: [],
      yearsExperience: 5,
      estimatedDuration: '10 días',
      status: ProposalStatus.rejected,
      rejectedAt: DateTime.now().subtract(const Duration(hours: 1)),
      rejectionReason: 'Tarifa muy alta para el presupuesto disponible',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // Propuestas para "Maestro de Obra para Proyecto Residencial" (job_3, clientId: 1)
    ProposalModel(
      id: 'prop_4',
      jobPostId: '3', // Maestro de Obra - cliente@test.com
      jobTitle: 'Maestro de Obra para Proyecto Residencial',
      professionalId: '2',
      professionalName: 'María González',
      message: 'Maestro de obra con 15 años de experiencia supervisando proyectos residenciales. Manejo de cuadrillas, lectura de planos, y control de calidad. Referencias verificables.',
      proposedRate: 70.0,
      rateType: 'por_dia',
      availableFrom: DateTime.now().add(const Duration(days: 3)),
      portfolioUrls: [
        'https://example.com/portfolio/construction-1.jpg',
        'https://example.com/portfolio/construction-2.jpg',
      ],
      yearsExperience: 15,
      estimatedDuration: '6 meses',
      status: ProposalStatus.accepted,
      acceptedAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    ProposalModel(
      id: 'prop_5',
      jobPostId: '3', // Maestro de Obra - cliente@test.com
      jobTitle: 'Maestro de Obra para Proyecto Residencial',
      professionalId: '4',
      professionalName: 'Carlos Rodríguez',
      message: 'Tengo amplia experiencia como maestro de obra. Puedo coordinar todo el equipo de trabajo y garantizar cumplimiento de plazos.',
      proposedRate: 65.0,
      rateType: 'por_dia',
      availableFrom: DateTime.now().add(const Duration(days: 7)),
      portfolioUrls: [],
      yearsExperience: 8,
      estimatedDuration: '6 meses',
      status: ProposalStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),

    // Propuesta para "Se Necesitan 3 Albañiles" (job_2, clientId: 3 - no del cliente actual)
    ProposalModel(
      id: 'prop_6',
      jobPostId: '2', // Albañiles - otro cliente
      jobTitle: 'Se Necesitan 3 Albañiles para Obra en Tumbaco',
      professionalId: '2',
      professionalName: 'María González',
      message: 'Somos un equipo de 3 albañiles con experiencia en construcción de viviendas.',
      proposedRate: 40.0,
      rateType: 'por_dia',
      availableFrom: DateTime.now().add(const Duration(days: 2)),
      portfolioUrls: [],
      yearsExperience: 5,
      estimatedDuration: '2 meses',
      status: ProposalStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
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

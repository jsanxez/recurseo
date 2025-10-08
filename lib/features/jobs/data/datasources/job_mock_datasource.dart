import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/jobs/data/models/job_post_model.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';

/// DataSource mock para ofertas de trabajo (datos de prueba)
class JobMockDataSource {
  final _logger = const Logger('JobMockDataSource');

  // Ofertas de trabajo de prueba - simulando sector construcción en Quito, Ecuador
  static final _mockJobPosts = <JobPostModel>[
    // 1. Trabajo urgente de electricista
    JobPostModel(
      id: '1',
      clientId: '1', // Juan Pérez (cliente)
      categoryIds: ['2'], // Electricidad
      title: 'Electricista Urgente para Instalación Residencial',
      description:
          'Necesito electricista con experiencia para instalación completa de circuitos en casa nueva. '
          'Trabajo incluye: tablero principal, tomacorrientes, iluminación, y conexión medidor. '
          'Casa de 2 pisos, aproximadamente 150m2. Debe traer herramientas.',
      location: 'Cumbayá, Quito',
      type: JobType.porProyecto,
      durationDays: 10,
      paymentType: PaymentType.porProyecto,
      budgetMin: 1200,
      budgetMax: 1800,
      urgency: UrgencyLevel.urgente,
      requiredWorkers: 1,
      requirements: [
        'Mínimo 3 años de experiencia',
        'Herramientas propias',
        'Referencias comprobables',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      proposalsCount: 5,
    ),

    // 2. Albañiles para construcción
    JobPostModel(
      id: '2',
      clientId: '3', // Carlos Admin (cliente)
      categoryIds: ['1'], // Construcción/Albañilería
      title: 'Se Necesitan 3 Albañiles para Obra en Tumbaco',
      description:
          'Proyecto de construcción de casa de 3 pisos. Se requieren albañiles con experiencia '
          'para levantamiento de paredes, enlucidos, y acabados. Trabajo estimado de 2 meses. '
          'Pago quincenal. Horario: Lunes a Sábado de 7am a 4pm.',
      location: 'Tumbaco, Quito',
      type: JobType.temporal,
      durationDays: 60,
      paymentType: PaymentType.porDia,
      budgetMin: 35,
      budgetMax: 45,
      urgency: UrgencyLevel.normal,
      requiredWorkers: 3,
      requirements: [
        'Experiencia mínima 2 años',
        'Disponibilidad inmediata',
        'Trabajo en equipo',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      expiresAt: DateTime.now().add(const Duration(days: 15)),
      proposalsCount: 12,
    ),

    // 3. Maestro de obra
    JobPostModel(
      id: '3',
      clientId: '1',
      categoryIds: ['1'],
      title: 'Maestro de Obra para Proyecto Residencial',
      description:
          'Busco maestro de obra con experiencia para supervisar construcción de casa. '
          'Responsabilidades: coordinar personal, supervisar calidad, control de materiales, '
          'y reporte de avances. Proyecto de 6 meses aproximadamente.',
      location: 'Conocoto, Quito',
      type: JobType.temporal,
      durationDays: 180,
      paymentType: PaymentType.porDia,
      budgetMin: 60,
      budgetMax: 80,
      urgency: UrgencyLevel.normal,
      requiredWorkers: 1,
      requirements: [
        'Experiencia mínima 5 años como maestro',
        'Conocimiento en lectura de planos',
        'Referencias verificables',
        'Disponibilidad tiempo completo',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 20)),
      proposalsCount: 3,
    ),

    // 4. Plomero para emergencia
    JobPostModel(
      id: '4',
      clientId: '3',
      categoryIds: ['1'], // Plomería
      title: 'Plomero Urgente - Fuga de Agua en Edificio',
      description:
          'Necesito plomero URGENTE para reparar fuga en tubería principal de edificio. '
          'El problema está en el sótano. Se requiere atención inmediata. '
          'Pago por trabajo realizado más bono por urgencia.',
      location: 'La Carolina, Quito',
      type: JobType.porProyecto,
      paymentType: PaymentType.porProyecto,
      budgetMin: 200,
      budgetMax: 400,
      urgency: UrgencyLevel.urgente,
      requiredWorkers: 1,
      requirements: [
        'Disponibilidad INMEDIATA',
        'Herramientas propias',
        'Experiencia en tuberías de edificios',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      expiresAt: DateTime.now().add(const Duration(days: 2)),
      proposalsCount: 8,
    ),

    // 5. Pintor para departamento
    JobPostModel(
      id: '5',
      clientId: '1',
      categoryIds: ['5'], // Pintura
      title: 'Pintor para Departamento 80m2',
      description:
          'Necesito pintor para pintar departamento completo (3 dormitorios, sala, comedor, cocina). '
          'Pintura en buen estado, solo cambio de color. Incluye empaste de pequeños huecos. '
          'Fechas flexibles, puede ser fines de semana.',
      location: 'El Batán, Quito',
      type: JobType.porProyecto,
      durationDays: 5,
      paymentType: PaymentType.porProyecto,
      budgetMin: 400,
      budgetMax: 600,
      urgency: UrgencyLevel.flexible,
      requiredWorkers: 1,
      requirements: [
        'Experiencia en pintura de interiores',
        'Trabajo prolijo',
        'Material incluido en presupuesto',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      expiresAt: DateTime.now().add(const Duration(days: 25)),
      proposalsCount: 7,
    ),

    // 6. Operarios para desbanque
    JobPostModel(
      id: '6',
      clientId: '3',
      categoryIds: ['1'],
      title: 'Operarios para Desbanque de Terreno',
      description:
          'Se necesitan 4 operarios para trabajo de desbanque y nivelación de terreno. '
          'Trabajo físico pesado. Duración aproximada 2 semanas. '
          'Pago diario en efectivo. Incluye almuerzo.',
      location: 'Puembo, Quito',
      type: JobType.temporal,
      durationDays: 14,
      paymentType: PaymentType.porDia,
      budgetMin: 25,
      budgetMax: 30,
      urgency: UrgencyLevel.normal,
      requiredWorkers: 4,
      requirements: [
        'Buena condición física',
        'Disponibilidad inmediata',
        'Transporte propio (opcional)',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      expiresAt: DateTime.now().add(const Duration(days: 5)),
      proposalsCount: 15,
    ),

    // 7. Carpintero para muebles
    JobPostModel(
      id: '7',
      clientId: '1',
      categoryIds: ['4'], // Carpintería
      title: 'Carpintero para Closets y Muebles de Cocina',
      description:
          'Busco carpintero experimentado para fabricar e instalar closets en 3 habitaciones '
          'y muebles de cocina (altos y bajos). Medidas y diseño ya definidos. '
          'Material de madera y tableros a coordinar.',
      location: 'Cumbayá, Quito',
      type: JobType.porProyecto,
      durationDays: 20,
      paymentType: PaymentType.porProyecto,
      budgetMin: 2500,
      budgetMax: 3500,
      urgency: UrgencyLevel.normal,
      requiredWorkers: 1,
      requirements: [
        'Experiencia en muebles de cocina',
        'Portfolio de trabajos anteriores',
        'Herramientas de carpintería completas',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      proposalsCount: 4,
    ),

    // 8. Soldador para estructura metálica
    JobPostModel(
      id: '8',
      clientId: '3',
      categoryIds: ['1'],
      title: 'Soldador para Estructura Metálica de Galpón',
      description:
          'Proyecto de construcción de galpón industrial requiere soldador certificado. '
          'Trabajo de soldadura de vigas, columnas y estructura de techo. '
          'Debe tener experiencia en soldadura MIG/TIG. Trabajo de 1 mes.',
      location: 'Pifo, Quito',
      type: JobType.temporal,
      durationDays: 30,
      paymentType: PaymentType.porDia,
      budgetMin: 50,
      budgetMax: 70,
      urgency: UrgencyLevel.normal,
      requiredWorkers: 1,
      requirements: [
        'Certificación en soldadura',
        'Experiencia mínima 4 años',
        'Equipo de soldadura propio',
        'Disponibilidad tiempo completo',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      expiresAt: DateTime.now().add(const Duration(days: 18)),
      proposalsCount: 2,
    ),

    // 9. Trabajo completado (para testing)
    JobPostModel(
      id: '9',
      clientId: '1',
      categoryIds: ['6'], // Jardinería
      title: 'Jardinero para Mantenimiento Mensual',
      description:
          'Busco jardinero para mantenimiento mensual de jardín (200m2). '
          'Incluye: poda, corte de césped, limpieza de hojas, riego. ',
      location: 'San Rafael, Quito',
      type: JobType.permanente,
      paymentType: PaymentType.porDia,
      budgetMin: 40,
      budgetMax: 50,
      urgency: UrgencyLevel.flexible,
      requiredWorkers: 1,
      requirements: ['Experiencia en jardinería'],
      photoUrls: [],
      status: JobPostStatus.filled,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      expiresAt: DateTime.now().add(const Duration(days: 15)),
      proposalsCount: 6,
    ),

    // 10. Electricista + Plomero (múltiples categorías)
    JobPostModel(
      id: '10',
      clientId: '3',
      categoryIds: ['1', '2'], // Plomería + Electricidad
      title: 'Profesional para Acabados de Baño (Eléctrico + Plomería)',
      description:
          'Necesito profesional que maneje tanto instalación eléctrica como plomería '
          'para acabados de 2 baños. Incluye: instalación de sanitarios, grifería, '
          'duchas, conexiones eléctricas, y enchufes. Proyecto pequeño pero requiere ambas especialidades.',
      location: 'Quito Norte, La Prensa',
      type: JobType.porProyecto,
      durationDays: 7,
      paymentType: PaymentType.porProyecto,
      budgetMin: 800,
      budgetMax: 1200,
      urgency: UrgencyLevel.normal,
      requiredWorkers: 1,
      requirements: [
        'Conocimiento en plomería Y electricidad',
        'Herramientas propias',
        'Referencias',
      ],
      photoUrls: [],
      status: JobPostStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      expiresAt: DateTime.now().add(const Duration(days: 10)),
      proposalsCount: 3,
    ),
  ];

  /// Obtener todas las ofertas (con filtros opcionales)
  Future<List<JobPostModel>> getJobPosts({
    JobSearchFilters? filters,
    JobSortOption? sortBy,
    int? limit,
  }) async {
    _logger.info('Mock: Getting job posts with filters');
    await Future.delayed(const Duration(milliseconds: 500));

    var filtered = List<JobPostModel>.from(_mockJobPosts);

    // Aplicar filtros
    if (filters != null) {
      if (filters.onlyActive == true) {
        filtered = filtered
            .where((job) => job.status == JobPostStatus.open && !job.isExpired)
            .toList();
      }

      if (filters.categoryIds != null && filters.categoryIds!.isNotEmpty) {
        filtered = filtered.where((job) {
          return job.categoryIds
              .any((catId) => filters.categoryIds!.contains(catId));
        }).toList();
      }

      if (filters.location != null) {
        filtered = filtered
            .where((job) => job.location
                .toLowerCase()
                .contains(filters.location!.toLowerCase()))
            .toList();
      }

      if (filters.type != null) {
        filtered = filtered.where((job) => job.type == filters.type).toList();
      }

      if (filters.urgency != null) {
        filtered =
            filtered.where((job) => job.urgency == filters.urgency).toList();
      }

      if (filters.minBudget != null) {
        filtered = filtered.where((job) {
          return job.budgetMax != null && job.budgetMax! >= filters.minBudget!;
        }).toList();
      }

      if (filters.maxBudget != null) {
        filtered = filtered.where((job) {
          return job.budgetMin != null && job.budgetMin! <= filters.maxBudget!;
        }).toList();
      }
    }

    // Aplicar ordenamiento
    if (sortBy != null) {
      switch (sortBy) {
        case JobSortOption.recent:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        case JobSortOption.urgent:
          filtered.sort((a, b) {
            if (a.urgency == UrgencyLevel.urgente &&
                b.urgency != UrgencyLevel.urgente) return -1;
            if (a.urgency != UrgencyLevel.urgente &&
                b.urgency == UrgencyLevel.urgente) return 1;
            return b.createdAt.compareTo(a.createdAt);
          });
        case JobSortOption.highestBudget:
          filtered.sort((a, b) {
            final aMax = a.budgetMax ?? 0;
            final bMax = b.budgetMax ?? 0;
            return bMax.compareTo(aMax);
          });
        case JobSortOption.lowestBudget:
          filtered.sort((a, b) {
            final aMin = a.budgetMin ?? double.infinity;
            final bMin = b.budgetMin ?? double.infinity;
            return aMin.compareTo(bMin);
          });
        case JobSortOption.expiringSoon:
          filtered.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
      }
    } else {
      // Por defecto: más recientes primero
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    // Aplicar límite
    if (limit != null && limit < filtered.length) {
      filtered = filtered.take(limit).toList();
    }

    return filtered;
  }

  /// Obtener ofertas de un cliente
  Future<List<JobPostModel>> getClientJobPosts(String clientId) async {
    _logger.info('Mock: Getting job posts for client $clientId');
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockJobPosts
        .where((job) => job.clientId == clientId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Obtener una oferta específica
  Future<JobPostModel> getJobPost(String jobPostId) async {
    _logger.info('Mock: Getting job post $jobPostId');
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockJobPosts.firstWhere(
      (job) => job.id == jobPostId,
      orElse: () => throw Exception('Oferta de trabajo no encontrada'),
    );
  }

  /// Crear nueva oferta
  Future<JobPostModel> createJobPost(JobPostModel jobPost) async {
    _logger.info('Mock: Creating job post');
    await Future.delayed(const Duration(milliseconds: 600));

    final newJobPost = jobPost.copyWith(
      id: '${_mockJobPosts.length + 1}',
      createdAt: DateTime.now(),
      status: JobPostStatus.open,
      proposalsCount: 0,
    );

    _mockJobPosts.add(newJobPost);
    return newJobPost;
  }

  /// Actualizar oferta
  Future<JobPostModel> updateJobPost(JobPostModel jobPost) async {
    _logger.info('Mock: Updating job post ${jobPost.id}');
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockJobPosts.indexWhere((j) => j.id == jobPost.id);
    if (index == -1) {
      throw Exception('Oferta no encontrada');
    }

    final updated = jobPost.copyWith(updatedAt: DateTime.now());
    _mockJobPosts[index] = updated;
    return updated;
  }

  /// Cerrar oferta
  Future<void> closeJobPost(String jobPostId) async {
    _logger.info('Mock: Closing job post $jobPostId');
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockJobPosts.indexWhere((j) => j.id == jobPostId);
    if (index != -1) {
      _mockJobPosts[index] = _mockJobPosts[index].copyWith(
        status: JobPostStatus.closed,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Marcar como llena
  Future<void> markJobPostFilled(String jobPostId) async {
    _logger.info('Mock: Marking job post $jobPostId as filled');
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockJobPosts.indexWhere((j) => j.id == jobPostId);
    if (index != -1) {
      _mockJobPosts[index] = _mockJobPosts[index].copyWith(
        status: JobPostStatus.filled,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Incrementar contador de propuestas
  Future<void> incrementProposalsCount(String jobPostId) async {
    final index = _mockJobPosts.indexWhere((j) => j.id == jobPostId);
    if (index != -1) {
      _mockJobPosts[index] = _mockJobPosts[index].copyWith(
        proposalsCount: _mockJobPosts[index].proposalsCount + 1,
      );
    }
  }

  /// Obtener estadísticas
  Future<ClientJobStats> getClientJobStats(String clientId) async {
    _logger.info('Mock: Getting stats for client $clientId');
    await Future.delayed(const Duration(milliseconds: 300));

    final clientJobs =
        _mockJobPosts.where((j) => j.clientId == clientId).toList();

    return ClientJobStats(
      totalPosts: clientJobs.length,
      activePosts:
          clientJobs.where((j) => j.status == JobPostStatus.open).length,
      closedPosts:
          clientJobs.where((j) => j.status == JobPostStatus.closed).length,
      filledPosts:
          clientJobs.where((j) => j.status == JobPostStatus.filled).length,
      totalProposalsReceived:
          clientJobs.fold(0, (sum, job) => sum + job.proposalsCount),
    );
  }
}

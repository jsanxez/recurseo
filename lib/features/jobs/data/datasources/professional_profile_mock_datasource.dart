import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/jobs/data/models/professional_profile_model.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';

/// DataSource mock para perfiles profesionales (datos de prueba)
class ProfessionalProfileMockDataSource {
  final _logger = const Logger('ProfessionalProfileMockDataSource');

  // Perfiles profesionales de prueba
  static final _mockProfiles = <ProfessionalProfileModel>[
    // María González - Profesional principal
    ProfessionalProfileModel(
      id: 'profile_1',
      userId: '2', // profesional@test.com
      trades: [Trade.electricista, Trade.plomero],
      experienceYears: 8,
      availability: AvailabilityStatus.disponible,
      hasOwnTools: true,
      hasOwnTransport: true,
      lookingForWork: true,
      hourlyRate: 50.0,
      dailyRate: 400.0,
      bio: 'Electricista y plomera profesional con 8 años de experiencia en el sector de la construcción. Especializada en instalaciones residenciales y comerciales. Cuento con licencia profesional vigente y certificaciones en seguridad eléctrica.',
      skills: [
        'Instalaciones eléctricas residenciales',
        'Cableado estructurado',
        'Instalaciones de plomería',
        'Reparaciones generales',
        'Lectura de planos',
      ],
      certifications: [
        'Licencia Profesional de Electricista',
        'Certificación en Seguridad Eléctrica',
        'Curso de Primeros Auxilios',
      ],
      portfolioUrls: [
        'https://example.com/portfolio/maria-1.jpg',
        'https://example.com/portfolio/maria-2.jpg',
        'https://example.com/portfolio/maria-3.jpg',
      ],
      serviceRadius: 15.0,
      preferredPaymentType: PaymentType.porDia,
      willingToTravel: true,
      languages: ['Español', 'Inglés Básico'],
      completedProjects: 45,
      averageRating: 4.8,
      totalReviews: 38,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Perfil de albañil experimentado
    ProfessionalProfileModel(
      id: 'profile_2',
      userId: '4',
      trades: [Trade.albanil, Trade.ayudante],
      experienceYears: 12,
      availability: AvailabilityStatus.parcial,
      hasOwnTools: true,
      hasOwnTransport: false,
      lookingForWork: true,
      dailyRate: 45.0,
      bio: 'Albañil con más de 12 años de experiencia en construcción de viviendas, edificios y obras civiles. Trabajo con equipos o de manera independiente.',
      skills: [
        'Construcción de paredes y muros',
        'Colocación de pisos y cerámicas',
        'Enlucido y acabados',
        'Lectura de planos arquitectónicos',
        'Construcción de losas',
      ],
      certifications: [
        'Certificado de Albañilería',
      ],
      portfolioUrls: [
        'https://example.com/portfolio/albanil-1.jpg',
        'https://example.com/portfolio/albanil-2.jpg',
      ],
      serviceRadius: 10.0,
      preferredPaymentType: PaymentType.porDia,
      willingToTravel: false,
      languages: ['Español'],
      completedProjects: 78,
      averageRating: 4.6,
      totalReviews: 62,
      lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // Perfil de pintor profesional
    ProfessionalProfileModel(
      id: 'profile_3',
      userId: '5',
      trades: [Trade.pintor],
      experienceYears: 10,
      availability: AvailabilityStatus.disponible,
      hasOwnTools: true,
      hasOwnTransport: true,
      lookingForWork: true,
      hourlyRate: 25.0,
      dailyRate: 200.0,
      bio: 'Pintor profesional especializado en interiores y exteriores. Trabajo con pinturas de alta calidad y ofrezco garantía en todos mis trabajos.',
      skills: [
        'Pintura de interiores',
        'Pintura de exteriores',
        'Texturizados y decorativos',
        'Preparación de superficies',
        'Aplicación de barnices',
      ],
      certifications: [
        'Certificado de Pintura Profesional',
      ],
      portfolioUrls: [
        'https://example.com/portfolio/pintor-1.jpg',
        'https://example.com/portfolio/pintor-2.jpg',
        'https://example.com/portfolio/pintor-3.jpg',
        'https://example.com/portfolio/pintor-4.jpg',
      ],
      serviceRadius: 20.0,
      preferredPaymentType: PaymentType.porProyecto,
      willingToTravel: true,
      languages: ['Español'],
      completedProjects: 95,
      averageRating: 4.9,
      totalReviews: 87,
      lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // Perfil de carpintero
    ProfessionalProfileModel(
      id: 'profile_4',
      userId: '6',
      trades: [Trade.carpintero],
      experienceYears: 15,
      availability: AvailabilityStatus.ocupado,
      hasOwnTools: true,
      hasOwnTransport: true,
      lookingForWork: false,
      hourlyRate: 35.0,
      dailyRate: 280.0,
      bio: 'Maestro carpintero con 15 años de experiencia en muebles a medida, puertas, ventanas y trabajos de ebanistería fina.',
      skills: [
        'Fabricación de muebles',
        'Instalación de puertas y ventanas',
        'Trabajos de ebanistería',
        'Restauración de muebles',
        'Diseño de closets',
      ],
      certifications: [
        'Maestro Carpintero Certificado',
        'Certificación en Seguridad con Maquinaria',
      ],
      portfolioUrls: [
        'https://example.com/portfolio/carpintero-1.jpg',
        'https://example.com/portfolio/carpintero-2.jpg',
      ],
      serviceRadius: 12.0,
      preferredPaymentType: PaymentType.porProyecto,
      willingToTravel: false,
      languages: ['Español'],
      completedProjects: 120,
      averageRating: 4.95,
      totalReviews: 110,
      lastActive: DateTime.now().subtract(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),

    // Perfil de soldador
    ProfessionalProfileModel(
      id: 'profile_5',
      userId: '7',
      trades: [Trade.soldador, Trade.herrero],
      experienceYears: 7,
      availability: AvailabilityStatus.disponible,
      hasOwnTools: true,
      hasOwnTransport: false,
      lookingForWork: true,
      hourlyRate: 40.0,
      dailyRate: 320.0,
      bio: 'Soldador profesional especializado en estructuras metálicas, portones, rejas y trabajos de herrería en general.',
      skills: [
        'Soldadura MIG/MAG',
        'Soldadura con electrodo',
        'Fabricación de estructuras metálicas',
        'Instalación de portones',
        'Trabajos de herrería artística',
      ],
      certifications: [
        'Certificación de Soldador Profesional',
        'Curso de Seguridad Industrial',
      ],
      portfolioUrls: [
        'https://example.com/portfolio/soldador-1.jpg',
      ],
      serviceRadius: 8.0,
      preferredPaymentType: PaymentType.porProyecto,
      willingToTravel: false,
      languages: ['Español'],
      completedProjects: 34,
      averageRating: 4.7,
      totalReviews: 28,
      lastActive: DateTime.now().subtract(const Duration(hours: 8)),
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  /// Obtener perfil por ID de usuario
  Future<ProfessionalProfileModel?> getProfileByUserId(String userId) async {
    _logger.info('Mock: Getting profile for user $userId');
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final profile = _mockProfiles.firstWhere((p) => p.userId == userId);
      _logger.success('Mock: Profile found');
      return profile;
    } catch (e) {
      _logger.info('Mock: No profile found for user $userId');
      return null;
    }
  }

  /// Obtener perfil por ID
  Future<ProfessionalProfileModel> getProfileById(String profileId) async {
    _logger.info('Mock: Getting profile $profileId');
    await Future.delayed(const Duration(milliseconds: 300));

    final profile = _mockProfiles.firstWhere(
      (p) => p.id == profileId,
      orElse: () => throw Exception('Perfil profesional no encontrado'),
    );

    return profile;
  }

  /// Buscar perfiles profesionales con filtros
  Future<List<ProfessionalProfileModel>> searchProfiles({
    List<Trade>? trades,
    AvailabilityStatus? availability,
    double? maxHourlyRate,
    double? maxDailyRate,
    bool? hasOwnTools,
    bool? hasOwnTransport,
    bool? lookingForWork,
    double? minRating,
    int? minExperienceYears,
  }) async {
    _logger.info('Mock: Searching professional profiles');
    await Future.delayed(const Duration(milliseconds: 500));

    var results = List<ProfessionalProfileModel>.from(_mockProfiles);

    // Filtrar por oficios
    if (trades != null && trades.isNotEmpty) {
      results = results.where((p) {
        return p.trades.any((t) => trades.contains(t));
      }).toList();
    }

    // Filtrar por disponibilidad
    if (availability != null) {
      results = results.where((p) => p.availability == availability).toList();
    }

    // Filtrar por tarifa por hora
    if (maxHourlyRate != null) {
      results = results.where((p) {
        return p.hourlyRate == null || p.hourlyRate! <= maxHourlyRate;
      }).toList();
    }

    // Filtrar por tarifa por día
    if (maxDailyRate != null) {
      results = results.where((p) {
        return p.dailyRate == null || p.dailyRate! <= maxDailyRate;
      }).toList();
    }

    // Filtrar por herramientas propias
    if (hasOwnTools != null) {
      results = results.where((p) => p.hasOwnTools == hasOwnTools).toList();
    }

    // Filtrar por transporte propio
    if (hasOwnTransport != null) {
      results = results.where((p) => p.hasOwnTransport == hasOwnTransport).toList();
    }

    // Filtrar por búsqueda de trabajo
    if (lookingForWork != null) {
      results = results.where((p) => p.lookingForWork == lookingForWork).toList();
    }

    // Filtrar por calificación mínima
    if (minRating != null) {
      results = results.where((p) {
        return p.averageRating != null && p.averageRating! >= minRating;
      }).toList();
    }

    // Filtrar por años de experiencia mínimos
    if (minExperienceYears != null) {
      results = results.where((p) => p.experienceYears >= minExperienceYears).toList();
    }

    _logger.success('Mock: Found ${results.length} profiles');
    return results;
  }

  /// Crear nuevo perfil profesional
  Future<ProfessionalProfileModel> createProfile({
    required String userId,
    required List<Trade> trades,
    required int experienceYears,
    required bool hasOwnTools,
    required bool hasOwnTransport,
    double? hourlyRate,
    double? dailyRate,
    String? bio,
    List<String>? skills,
    List<String>? certifications,
  }) async {
    _logger.info('Mock: Creating professional profile for user $userId');
    await Future.delayed(const Duration(milliseconds: 600));

    // Verificar si ya existe un perfil para este usuario
    final existingProfile = _mockProfiles.any((p) => p.userId == userId);

    if (existingProfile) {
      throw Exception('Ya existe un perfil profesional para este usuario');
    }

    final newProfile = ProfessionalProfileModel(
      id: 'profile_${_mockProfiles.length + 1}',
      userId: userId,
      trades: trades,
      experienceYears: experienceYears,
      availability: AvailabilityStatus.disponible,
      hasOwnTools: hasOwnTools,
      hasOwnTransport: hasOwnTransport,
      lookingForWork: true,
      hourlyRate: hourlyRate,
      dailyRate: dailyRate,
      bio: bio,
      skills: skills ?? [],
      certifications: certifications ?? [],
      portfolioUrls: [],
      completedProjects: 0,
      lastActive: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockProfiles.add(newProfile);
    _logger.success('Mock: Professional profile created successfully');

    return newProfile;
  }

  /// Actualizar perfil profesional
  Future<ProfessionalProfileModel> updateProfile({
    required String profileId,
    List<Trade>? trades,
    int? experienceYears,
    AvailabilityStatus? availability,
    bool? hasOwnTools,
    bool? hasOwnTransport,
    bool? lookingForWork,
    double? hourlyRate,
    double? dailyRate,
    String? bio,
    List<String>? skills,
    List<String>? certifications,
    List<String>? portfolioUrls,
    double? serviceRadius,
    PaymentType? preferredPaymentType,
    bool? willingToTravel,
    List<String>? languages,
  }) async {
    _logger.info('Mock: Updating professional profile $profileId');
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProfiles.indexWhere((p) => p.id == profileId);

    if (index == -1) {
      throw Exception('Perfil profesional no encontrado');
    }

    final profile = _mockProfiles[index];

    final updatedProfile = profile.copyWith(
      trades: trades,
      experienceYears: experienceYears,
      availability: availability,
      hasOwnTools: hasOwnTools,
      hasOwnTransport: hasOwnTransport,
      lookingForWork: lookingForWork,
      hourlyRate: hourlyRate,
      dailyRate: dailyRate,
      bio: bio,
      skills: skills,
      certifications: certifications,
      portfolioUrls: portfolioUrls,
      serviceRadius: serviceRadius,
      preferredPaymentType: preferredPaymentType,
      willingToTravel: willingToTravel,
      languages: languages,
      updatedAt: DateTime.now(),
    );

    _mockProfiles[index] = updatedProfile;
    _logger.success('Mock: Professional profile updated successfully');

    return updatedProfile;
  }

  /// Eliminar perfil profesional
  Future<void> deleteProfile(String profileId) async {
    _logger.info('Mock: Deleting professional profile $profileId');
    await Future.delayed(const Duration(milliseconds: 400));

    final initialLength = _mockProfiles.length;
    _mockProfiles.removeWhere((p) => p.id == profileId);
    final removed = initialLength - _mockProfiles.length;

    if (removed == 0) {
      throw Exception('Perfil profesional no encontrado');
    }

    _logger.success('Mock: Professional profile deleted successfully');
  }

  /// Obtener perfiles destacados (mejor calificados y más activos)
  Future<List<ProfessionalProfileModel>> getFeaturedProfiles({
    int limit = 10,
  }) async {
    _logger.info('Mock: Getting featured professional profiles');
    await Future.delayed(const Duration(milliseconds: 400));

    final featured = _mockProfiles
        .where((p) => p.lookingForWork && p.averageRating != null)
        .toList()
      ..sort((a, b) {
        // Ordenar por calificación y luego por proyectos completados
        final ratingComparison = (b.averageRating ?? 0).compareTo(a.averageRating ?? 0);
        if (ratingComparison != 0) return ratingComparison;
        return (b.completedProjects ?? b.completedJobs).compareTo(a.completedProjects ?? a.completedJobs);
      });

    final result = featured.take(limit).toList();
    _logger.success('Mock: Found ${result.length} featured profiles');

    return result;
  }
}

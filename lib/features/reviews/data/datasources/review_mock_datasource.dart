import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/reviews/data/models/review_model.dart';
import 'package:recurseo/features/reviews/domain/repositories/review_repository.dart';

/// DataSource mock para reseñas (datos de prueba)
class ReviewMockDataSource {
  final _logger = const Logger('ReviewMockDataSource');

  // Reseñas de prueba
  static final _mockReviews = <ReviewModel>[
    // Reseñas para Servicio 1: Reparación de Tuberías (proveedor María González)
    ReviewModel(
      id: '1',
      serviceId: '1',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 5,
      comment:
          'Excelente servicio! María llegó a tiempo, identificó el problema rápidamente y lo solucionó de manera profesional. Muy recomendada.',
      isVerified: true,
      requestId: '4', // Solicitud completada
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    ReviewModel(
      id: '2',
      serviceId: '1',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Trabajo impecable. Solucionó una fuga que otros plomeros no pudieron reparar. Precios justos y excelente atención.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),

    // Reseñas para Servicio 2: Instalación de Grifos
    ReviewModel(
      id: '3',
      serviceId: '2',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 5,
      comment:
          'Instaló dos grifos en mi cocina y quedaron perfectos. Muy profesional y dejó todo limpio.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),

    // Reseñas para Servicio 3: Instalación Eléctrica Residencial
    ReviewModel(
      id: '4',
      serviceId: '3',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Realizó toda la instalación eléctrica de mi oficina. Trabajo de primera calidad, cumplió con todos los códigos eléctricos.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    ReviewModel(
      id: '5',
      serviceId: '3',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 4,
      comment:
          'Buen servicio. Tardó un poco más de lo estimado pero el resultado final fue muy bueno.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
    ),

    // Reseñas para Servicio 4: Reparación de Cortocircuitos
    ReviewModel(
      id: '6',
      serviceId: '4',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Servicio de emergencia excelente. Llegó en menos de 2 horas y solucionó el problema rápidamente. Muy profesional.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),

    // Reseñas para Servicio 5: Limpieza Profunda de Hogar
    ReviewModel(
      id: '7',
      serviceId: '5',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 5,
      comment:
          '¡Mi casa quedó reluciente! Muy detallistas, limpiaron hasta los rincones más difíciles. Totalmente recomendado.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    ReviewModel(
      id: '8',
      serviceId: '5',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Servicio impecable. El equipo fue muy profesional y respetuoso con mis pertenencias. Volveré a contratarlos.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 55)),
    ),

    // Reseñas para Servicio 6: Limpieza de Oficinas
    ReviewModel(
      id: '9',
      serviceId: '6',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Servicio de limpieza semanal para mi oficina. Siempre puntuales y hacen un trabajo excelente. Muy confiables.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),

    // Reseñas para Servicio 7: Fabricación de Muebles a Medida
    ReviewModel(
      id: '10',
      serviceId: '7',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 5,
      comment:
          'Fabricó un closet a medida para mi habitación. El diseño quedó perfecto y la calidad de la madera es excelente.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
    ReviewModel(
      id: '11',
      serviceId: '7',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 4,
      comment:
          'Muy buen trabajo. El mueble quedó hermoso, aunque tardó un poco más de lo acordado. Pero vale la pena la espera.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
    ),

    // Reseñas para Servicio 9: Pintura de Interiores
    ReviewModel(
      id: '12',
      serviceId: '9',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 5,
      comment:
          'Pintaron mi sala y comedor. Trabajo prolijo, protegieron todos los muebles y dejaron todo limpio. Muy profesionales.',
      isVerified: true,
      requestId: '4',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),

    // Reseñas para Servicio 11: Mantenimiento de Jardines
    ReviewModel(
      id: '13',
      serviceId: '11',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Servicio mensual de mantenimiento. Mi jardín siempre se ve hermoso gracias a su trabajo. Muy recomendados.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 22)),
    ),

    // Reseñas para Servicio 12: Diseño de Jardines
    ReviewModel(
      id: '14',
      serviceId: '12',
      clientId: '1',
      clientName: 'Juan Pérez',
      providerId: '2',
      rating: 5,
      comment:
          'Diseñaron y crearon mi jardín desde cero. El resultado superó mis expectativas. Tienen muy buen gusto y conocen bien las plantas.',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 33)),
    ),
    ReviewModel(
      id: '15',
      serviceId: '12',
      clientId: '3',
      clientName: 'Carlos Admin',
      providerId: '2',
      rating: 5,
      comment:
          'Excelente diseño de jardín. Incluyeron sistema de riego automático y seleccionaron plantas perfectas para el clima. ¡Encantado!',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  /// Obtener reseñas de un servicio
  Future<List<ReviewModel>> getServiceReviews(String serviceId) async {
    _logger.info('Mock: Getting reviews for service $serviceId');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockReviews.where((r) => r.serviceId == serviceId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Más recientes primero
  }

  /// Obtener reseñas de un proveedor
  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    _logger.info('Mock: Getting reviews for provider $providerId');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockReviews.where((r) => r.providerId == providerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Obtener una reseña específica
  Future<ReviewModel> getReview(String reviewId) async {
    _logger.info('Mock: Getting review $reviewId');
    await Future.delayed(const Duration(milliseconds: 400));

    final review = _mockReviews.firstWhere(
      (r) => r.id == reviewId,
      orElse: () => throw Exception('Reseña no encontrada'),
    );

    return review;
  }

  /// Crear una nueva reseña
  Future<ReviewModel> createReview({
    required String clientId,
    required String clientName,
    required String serviceId,
    required String providerId,
    required int rating,
    required String comment,
    String? requestId,
  }) async {
    _logger.info('Mock: Creating new review');
    await Future.delayed(const Duration(milliseconds: 800));

    final newReview = ReviewModel(
      id: '${_mockReviews.length + 1}',
      serviceId: serviceId,
      clientId: clientId,
      clientName: clientName,
      providerId: providerId,
      rating: rating,
      comment: comment,
      isVerified: requestId != null,
      requestId: requestId,
      createdAt: DateTime.now(),
    );

    _mockReviews.add(newReview);
    return newReview;
  }

  /// Actualizar una reseña
  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    _logger.info('Mock: Updating review $reviewId');
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _mockReviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) {
      throw Exception('Reseña no encontrada');
    }

    final oldReview = _mockReviews[index];
    final updatedReview = ReviewModel(
      id: oldReview.id,
      serviceId: oldReview.serviceId,
      clientId: oldReview.clientId,
      clientName: oldReview.clientName,
      clientPhotoUrl: oldReview.clientPhotoUrl,
      providerId: oldReview.providerId,
      rating: rating ?? oldReview.rating,
      comment: comment ?? oldReview.comment,
      isVerified: oldReview.isVerified,
      requestId: oldReview.requestId,
      createdAt: oldReview.createdAt,
      updatedAt: DateTime.now(),
    );

    _mockReviews[index] = updatedReview;
    return updatedReview;
  }

  /// Eliminar una reseña
  Future<void> deleteReview(String reviewId) async {
    _logger.info('Mock: Deleting review $reviewId');
    await Future.delayed(const Duration(milliseconds: 500));

    _mockReviews.removeWhere((r) => r.id == reviewId);
  }

  /// Verificar si puede dejar reseña
  Future<bool> canReview({
    required String clientId,
    required String requestId,
    required String serviceId,
  }) async {
    _logger.info('Mock: Checking if can review for request $requestId');
    await Future.delayed(const Duration(milliseconds: 300));

    // Verificar si ya existe una reseña para este request
    final existingReview = _mockReviews.any((r) => r.requestId == requestId);

    return !existingReview;
  }

  /// Obtener estadísticas de reseñas de un servicio
  Future<ReviewStats> getServiceReviewStats(String serviceId) async {
    _logger.info('Mock: Getting review stats for service $serviceId');
    await Future.delayed(const Duration(milliseconds: 400));

    final reviews = _mockReviews.where((r) => r.serviceId == serviceId).toList();

    if (reviews.isEmpty) {
      return const ReviewStats(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {},
        verifiedReviews: 0,
      );
    }

    final totalRating = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    final averageRating = totalRating / reviews.length;

    final ratingDistribution = <int, int>{};
    for (var rating = 1; rating <= 5; rating++) {
      ratingDistribution[rating] =
          reviews.where((r) => r.rating == rating).length;
    }

    final verifiedCount = reviews.where((r) => r.isVerified).length;

    return ReviewStats(
      averageRating: averageRating,
      totalReviews: reviews.length,
      ratingDistribution: ratingDistribution,
      verifiedReviews: verifiedCount,
    );
  }

  /// Obtener estadísticas de reseñas de un proveedor
  Future<ReviewStats> getProviderReviewStats(String providerId) async {
    _logger.info('Mock: Getting review stats for provider $providerId');
    await Future.delayed(const Duration(milliseconds: 400));

    final reviews =
        _mockReviews.where((r) => r.providerId == providerId).toList();

    if (reviews.isEmpty) {
      return const ReviewStats(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {},
        verifiedReviews: 0,
      );
    }

    final totalRating = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    final averageRating = totalRating / reviews.length;

    final ratingDistribution = <int, int>{};
    for (var rating = 1; rating <= 5; rating++) {
      ratingDistribution[rating] =
          reviews.where((r) => r.rating == rating).length;
    }

    final verifiedCount = reviews.where((r) => r.isVerified).length;

    return ReviewStats(
      averageRating: averageRating,
      totalReviews: reviews.length,
      ratingDistribution: ratingDistribution,
      verifiedReviews: verifiedCount,
    );
  }
}

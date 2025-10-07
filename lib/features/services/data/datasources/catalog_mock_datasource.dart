import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/profile/data/models/service_model.dart';
import 'package:recurseo/features/services/data/models/category_model.dart';

/// DataSource mock para catálogo (datos de prueba)
class CatalogMockDataSource {
  final _logger = const Logger('CatalogMockDataSource');

  // Categorías de prueba
  static final _mockCategories = [
    const CategoryModel(
      id: '1',
      name: 'Plomería',
      description: 'Servicios de instalación y reparación de tuberías',
      iconName: 'plumbing',
      servicesCount: 2,
      isActive: true,
    ),
    const CategoryModel(
      id: '2',
      name: 'Electricidad',
      description: 'Instalación y mantenimiento eléctrico',
      iconName: 'electrical_services',
      servicesCount: 2,
      isActive: true,
    ),
    const CategoryModel(
      id: '3',
      name: 'Limpieza',
      description: 'Servicios de limpieza para hogar y oficina',
      iconName: 'cleaning_services',
      servicesCount: 2,
      isActive: true,
    ),
    const CategoryModel(
      id: '4',
      name: 'Carpintería',
      description: 'Trabajos en madera y muebles',
      iconName: 'build',
      servicesCount: 2,
      isActive: true,
    ),
    const CategoryModel(
      id: '5',
      name: 'Pintura',
      description: 'Pintura de interiores y exteriores',
      iconName: 'format_paint',
      servicesCount: 2,
      isActive: true,
    ),
    const CategoryModel(
      id: '6',
      name: 'Jardinería',
      description: 'Mantenimiento de jardines y áreas verdes',
      iconName: 'yard',
      servicesCount: 2,
      isActive: true,
    ),
    const CategoryModel(
      id: '7',
      name: 'Mudanzas',
      description: 'Servicios de transporte y mudanzas',
      iconName: 'local_shipping',
      servicesCount: 0,
      isActive: true,
    ),
    const CategoryModel(
      id: '8',
      name: 'Reparaciones',
      description: 'Reparación de electrodomésticos',
      iconName: 'home_repair_service',
      servicesCount: 0,
      isActive: true,
    ),
    const CategoryModel(
      id: '9',
      name: 'Refrigeración',
      description: 'Instalación y mantenimiento de aires acondicionados',
      iconName: 'build',
      servicesCount: 0,
      isActive: true,
    ),
    const CategoryModel(
      id: '10',
      name: 'Cerrajería',
      description: 'Apertura y cambio de cerraduras',
      iconName: 'build',
      servicesCount: 0,
      isActive: true,
    ),
  ];

  // Servicios de prueba
  static final _mockServices = [
    // Plomería
    ServiceModel(
      id: '1',
      providerId: '2', // María González (proveedor)
      categoryId: '1',
      title: 'Reparación de Tuberías',
      description:
          'Servicio profesional de reparación de tuberías con fugas, roturas o problemas de flujo. Incluye revisión completa del sistema.',
      priceFrom: 30.0,
      priceTo: 80.0,
      priceUnit: 'hour',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    ServiceModel(
      id: '2',
      providerId: '2',
      categoryId: '1',
      title: 'Instalación de Grifos',
      description:
          'Instalación profesional de grifos de cocina y baño. Garantía de 6 meses.',
      priceFrom: 25.0,
      priceTo: 50.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),

    // Electricidad
    ServiceModel(
      id: '3',
      providerId: '2',
      categoryId: '2',
      title: 'Instalación Eléctrica Residencial',
      description:
          'Instalación completa de sistemas eléctricos para hogares. Incluye tomacorrientes, interruptores y tableros.',
      priceFrom: 100.0,
      priceTo: 500.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    ServiceModel(
      id: '4',
      providerId: '2',
      categoryId: '2',
      title: 'Reparación de Cortocircuitos',
      description:
          'Diagnóstico y reparación de problemas eléctricos. Servicio de emergencia disponible 24/7.',
      priceFrom: 40.0,
      priceTo: 100.0,
      priceUnit: 'hour',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),

    // Limpieza
    ServiceModel(
      id: '5',
      providerId: '2',
      categoryId: '3',
      title: 'Limpieza Profunda de Hogar',
      description:
          'Servicio completo de limpieza que incluye pisos, ventanas, baños, cocina y habitaciones. Personal capacitado.',
      priceFrom: 50.0,
      priceTo: 150.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    ServiceModel(
      id: '6',
      providerId: '2',
      categoryId: '3',
      title: 'Limpieza de Oficinas',
      description:
          'Mantenimiento diario o semanal de oficinas. Incluye sanitización de áreas comunes.',
      priceFrom: 80.0,
      priceTo: 200.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),

    // Carpintería
    ServiceModel(
      id: '7',
      providerId: '2',
      categoryId: '4',
      title: 'Fabricación de Muebles a Medida',
      description:
          'Diseño y fabricación de muebles personalizados en madera de alta calidad. Closets, repisas, mesas.',
      priceFrom: 200.0,
      priceTo: 1000.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
    ServiceModel(
      id: '8',
      providerId: '2',
      categoryId: '4',
      title: 'Reparación de Muebles',
      description:
          'Restauración y reparación de muebles de madera. Barnizado y acabados.',
      priceFrom: 30.0,
      priceTo: 150.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
    ),

    // Pintura
    ServiceModel(
      id: '9',
      providerId: '2',
      categoryId: '5',
      title: 'Pintura de Interiores',
      description:
          'Servicio profesional de pintura para habitaciones, salas y espacios interiores. Incluye preparación de paredes.',
      priceFrom: 100.0,
      priceTo: 400.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    ServiceModel(
      id: '10',
      providerId: '2',
      categoryId: '5',
      title: 'Pintura de Fachadas',
      description:
          'Pintura exterior de casas y edificios. Trabajos en altura con equipos de seguridad.',
      priceFrom: 300.0,
      priceTo: 1500.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 28)),
    ),

    // Jardinería
    ServiceModel(
      id: '11',
      providerId: '2',
      categoryId: '6',
      title: 'Mantenimiento de Jardines',
      description:
          'Poda, corte de césped, control de plagas y fertilización. Servicio mensual disponible.',
      priceFrom: 40.0,
      priceTo: 120.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 22)),
    ),
    ServiceModel(
      id: '12',
      providerId: '2',
      categoryId: '6',
      title: 'Diseño de Jardines',
      description:
          'Diseño y creación de jardines desde cero. Incluye selección de plantas y sistema de riego.',
      priceFrom: 200.0,
      priceTo: 800.0,
      priceUnit: 'job',
      photoUrls: const [],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 33)),
    ),
  ];

  /// Obtener todas las categorías
  Future<List<CategoryModel>> getCategories() async {
    _logger.info('Mock: Getting categories');
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_mockCategories);
  }

  /// Obtener categoría por ID
  Future<CategoryModel> getCategoryById(String id) async {
    _logger.info('Mock: Getting category $id');
    await Future.delayed(const Duration(milliseconds: 400));

    final category = _mockCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Categoría no encontrada'),
    );

    return category;
  }

  /// Obtener servicios destacados (primeros 6 servicios)
  Future<List<ServiceModel>> getFeaturedServices() async {
    _logger.info('Mock: Getting featured services');
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockServices.take(6).toList();
  }

  /// Obtener servicios por categoría
  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    _logger.info('Mock: Getting services for category $categoryId');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockServices.where((s) => s.categoryId == categoryId).toList();
  }

  /// Obtener servicio por ID
  Future<ServiceModel> getServiceById(String serviceId) async {
    _logger.info('Mock: Getting service $serviceId');
    await Future.delayed(const Duration(milliseconds: 400));

    final service = _mockServices.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => throw Exception('Servicio no encontrado'),
    );

    return service;
  }

  /// Buscar servicios
  Future<List<ServiceModel>> searchServices(String query) async {
    _logger.info('Mock: Searching services with query: $query');
    await Future.delayed(const Duration(milliseconds: 600));

    final lowerQuery = query.toLowerCase();
    return _mockServices.where((s) {
      return s.title.toLowerCase().contains(lowerQuery) ||
          s.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Obtener favoritos (mock)
  Future<List<ServiceModel>> getFavorites(List<String> favoriteIds) async {
    _logger.info('Mock: Getting favorites');
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockServices.where((s) => favoriteIds.contains(s.id)).toList();
  }

  /// Toggle favorito (mock - retorna solo true/false)
  Future<bool> toggleFavorite(String serviceId, bool isFavorite) async {
    _logger.info('Mock: Toggle favorite for service $serviceId');
    await Future.delayed(const Duration(milliseconds: 300));
    return !isFavorite;
  }
}

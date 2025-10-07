import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/requests/data/models/request_model.dart';
import 'package:recurseo/features/requests/domain/entities/request_entity.dart';

/// DataSource mock para solicitudes (datos de prueba)
class RequestMockDataSource {
  final _logger = const Logger('RequestMockDataSource');

  // Solicitudes de prueba
  static final _mockRequests = <RequestModel>[
    // Solicitudes del cliente '1' (Juan Pérez)
    RequestModel(
      id: '1',
      clientId: '1',
      providerId: '2',
      serviceId: '1',
      title: 'Reparación urgente de tubería',
      description:
          'Tengo una fuga en la tubería del baño que necesita reparación urgente. El agua está goteando constantemente.',
      location: 'Av. 6 de Diciembre y Gaspar de Villarroel, Quito',
      preferredDate: DateTime.now().add(const Duration(days: 2)),
      budgetFrom: 50.0,
      budgetTo: 100.0,
      status: RequestStatus.accepted,
      providerResponse:
          'Perfecto, puedo atender tu solicitud. Llegaré con todas las herramientas necesarias.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RequestModel(
      id: '2',
      clientId: '1',
      providerId: '2',
      serviceId: '5',
      title: 'Limpieza profunda de departamento',
      description:
          'Necesito limpieza completa de un departamento de 3 habitaciones. Incluye ventanas, pisos y baños.',
      location: 'La Carolina, Quito',
      preferredDate: DateTime.now().add(const Duration(days: 5)),
      budgetFrom: 80.0,
      budgetTo: 120.0,
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RequestModel(
      id: '3',
      clientId: '1',
      providerId: '2',
      serviceId: '3',
      title: 'Instalación eléctrica para nuevo local',
      description:
          'Requiero instalación eléctrica completa para un local comercial de aproximadamente 100m2.',
      location: 'Centro Histórico, Quito',
      preferredDate: DateTime.now().add(const Duration(days: 10)),
      budgetFrom: 300.0,
      budgetTo: 500.0,
      status: RequestStatus.inProgress,
      providerResponse: 'Ya estamos trabajando en el proyecto.',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    RequestModel(
      id: '4',
      clientId: '1',
      providerId: '2',
      serviceId: '9',
      title: 'Pintura de sala y comedor',
      description:
          'Necesito pintar la sala y comedor de mi casa. Aproximadamente 40m2 de área.',
      location: 'Cumbayá, Quito',
      preferredDate: DateTime.now().subtract(const Duration(days: 20)),
      budgetFrom: 150.0,
      budgetTo: 250.0,
      status: RequestStatus.completed,
      providerResponse: 'Trabajo completado. ¡Gracias por confiar en nosotros!',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    RequestModel(
      id: '5',
      clientId: '1',
      providerId: '2',
      serviceId: '7',
      title: 'Fabricación de closet a medida',
      description:
          'Busco fabricar un closet personalizado para habitación principal. Necesito asesoría en diseño.',
      location: 'Tumbaco, Quito',
      budgetFrom: 400.0,
      budgetTo: 800.0,
      status: RequestStatus.rejected,
      providerResponse:
          'Lo siento, en este momento tengo la agenda llena. Te recomiendo contactar en 2 meses.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),

    // Solicitudes del proveedor '2' (María González) - vista desde proveedor
    RequestModel(
      id: '6',
      clientId: '3',
      providerId: '2',
      serviceId: '2',
      title: 'Instalación de grifos en cocina',
      description:
          'Necesito instalar 2 grifos nuevos en la cocina. Ya tengo los grifos comprados.',
      location: 'El Batán, Quito',
      preferredDate: DateTime.now().add(const Duration(days: 3)),
      budgetFrom: 30.0,
      budgetTo: 50.0,
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RequestModel(
      id: '7',
      clientId: '3',
      providerId: '2',
      serviceId: '4',
      title: 'Reparación de cortocircuito',
      description:
          'Los breakers se están disparando constantemente. Necesito revisión urgente del sistema eléctrico.',
      location: 'La Mariscal, Quito',
      preferredDate: DateTime.now().add(const Duration(days: 1)),
      budgetFrom: 50.0,
      budgetTo: 100.0,
      status: RequestStatus.accepted,
      providerResponse: 'Puedo atenderte mañana temprano. Llegaré a las 8am.',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  /// Obtener solicitudes del cliente
  Future<List<RequestModel>> getClientRequests(String clientId) async {
    _logger.info('Mock: Getting requests for client $clientId');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRequests.where((r) => r.clientId == clientId).toList();
  }

  /// Obtener solicitudes del proveedor
  Future<List<RequestModel>> getProviderRequests(String providerId) async {
    _logger.info('Mock: Getting requests for provider $providerId');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRequests.where((r) => r.providerId == providerId).toList();
  }

  /// Obtener solicitud por ID
  Future<RequestModel> getRequestById(String requestId) async {
    _logger.info('Mock: Getting request $requestId');
    await Future.delayed(const Duration(milliseconds: 400));

    final request = _mockRequests.firstWhere(
      (r) => r.id == requestId,
      orElse: () => throw Exception('Solicitud no encontrada'),
    );

    return request;
  }

  /// Crear nueva solicitud
  Future<RequestModel> createRequest({
    required String clientId,
    required String providerId,
    required String serviceId,
    required String title,
    required String description,
    String? location,
    DateTime? preferredDate,
    double? budgetFrom,
    double? budgetTo,
  }) async {
    _logger.info('Mock: Creating new request');
    await Future.delayed(const Duration(milliseconds: 800));

    final newRequest = RequestModel(
      id: '${_mockRequests.length + 1}',
      clientId: clientId,
      providerId: providerId,
      serviceId: serviceId,
      title: title,
      description: description,
      location: location,
      preferredDate: preferredDate,
      budgetFrom: budgetFrom,
      budgetTo: budgetTo,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );

    _mockRequests.add(newRequest);
    return newRequest;
  }

  /// Actualizar estado de solicitud
  Future<RequestModel> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? providerResponse,
  }) async {
    _logger.info('Mock: Updating request $requestId status to $status');
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _mockRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) {
      throw Exception('Solicitud no encontrada');
    }

    final updatedRequest = RequestModel(
      id: _mockRequests[index].id,
      clientId: _mockRequests[index].clientId,
      providerId: _mockRequests[index].providerId,
      serviceId: _mockRequests[index].serviceId,
      title: _mockRequests[index].title,
      description: _mockRequests[index].description,
      location: _mockRequests[index].location,
      preferredDate: _mockRequests[index].preferredDate,
      budgetFrom: _mockRequests[index].budgetFrom,
      budgetTo: _mockRequests[index].budgetTo,
      status: status,
      providerResponse: providerResponse ?? _mockRequests[index].providerResponse,
      createdAt: _mockRequests[index].createdAt,
      updatedAt: DateTime.now(),
    );

    _mockRequests[index] = updatedRequest;
    return updatedRequest;
  }

  /// Cancelar solicitud
  Future<void> cancelRequest(String requestId) async {
    _logger.info('Mock: Cancelling request $requestId');
    await Future.delayed(const Duration(milliseconds: 500));

    await updateRequestStatus(
      requestId: requestId,
      status: RequestStatus.cancelled,
    );
  }

  /// Aceptar solicitud (proveedor)
  Future<RequestModel> acceptRequest({
    required String requestId,
    String? response,
  }) async {
    _logger.info('Mock: Accepting request $requestId');
    await Future.delayed(const Duration(milliseconds: 600));

    return updateRequestStatus(
      requestId: requestId,
      status: RequestStatus.accepted,
      providerResponse: response ?? 'Solicitud aceptada',
    );
  }

  /// Rechazar solicitud (proveedor)
  Future<RequestModel> rejectRequest({
    required String requestId,
    String? response,
  }) async {
    _logger.info('Mock: Rejecting request $requestId');
    await Future.delayed(const Duration(milliseconds: 600));

    return updateRequestStatus(
      requestId: requestId,
      status: RequestStatus.rejected,
      providerResponse: response ?? 'Solicitud rechazada',
    );
  }

  /// Marcar como en progreso
  Future<RequestModel> markInProgress(String requestId) async {
    _logger.info('Mock: Marking request $requestId as in progress');
    await Future.delayed(const Duration(milliseconds: 500));

    return updateRequestStatus(
      requestId: requestId,
      status: RequestStatus.inProgress,
    );
  }

  /// Marcar como completada
  Future<RequestModel> markCompleted(String requestId) async {
    _logger.info('Mock: Marking request $requestId as completed');
    await Future.delayed(const Duration(milliseconds: 500));

    return updateRequestStatus(
      requestId: requestId,
      status: RequestStatus.completed,
    );
  }
}

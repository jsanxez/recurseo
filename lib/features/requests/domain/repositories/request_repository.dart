import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/requests/domain/entities/request_entity.dart';

/// Contrato del repositorio de solicitudes
abstract class RequestRepository {
  /// Crear nueva solicitud
  Future<Result<RequestEntity>> createRequest({
    required String providerId,
    required String serviceId,
    required String title,
    required String description,
    String? location,
    DateTime? preferredDate,
    double? budgetFrom,
    double? budgetTo,
  });

  /// Obtener solicitudes del cliente
  Future<Result<List<RequestEntity>>> getClientRequests(String clientId);

  /// Obtener solicitudes recibidas por el proveedor
  Future<Result<List<RequestEntity>>> getProviderRequests(String providerId);

  /// Obtener solicitud por ID
  Future<Result<RequestEntity>> getRequestById(String id);

  /// Aceptar solicitud (proveedor)
  Future<Result<RequestEntity>> acceptRequest({
    required String requestId,
    String? response,
  });

  /// Rechazar solicitud (proveedor)
  Future<Result<RequestEntity>> rejectRequest({
    required String requestId,
    required String reason,
  });

  /// Marcar como en progreso
  Future<Result<RequestEntity>> markAsInProgress(String requestId);

  /// Marcar como completada
  Future<Result<RequestEntity>> markAsCompleted(String requestId);

  /// Cancelar solicitud (cliente)
  Future<Result<RequestEntity>> cancelRequest(String requestId);
}

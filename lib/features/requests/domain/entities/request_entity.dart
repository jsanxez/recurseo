import 'package:equatable/equatable.dart';

/// Estado de una solicitud
enum RequestStatus {
  pending, // Pendiente de respuesta del proveedor
  accepted, // Aceptada por el proveedor
  rejected, // Rechazada por el proveedor
  inProgress, // En progreso
  completed, // Completada
  cancelled, // Cancelada por el cliente
}

/// Entidad de solicitud de servicio
class RequestEntity extends Equatable {
  final String id;
  final String clientId;
  final String providerId;
  final String serviceId;
  final String title;
  final String description;
  final String? location;
  final DateTime? preferredDate;
  final double? budgetFrom;
  final double? budgetTo;
  final RequestStatus status;
  final String? providerResponse;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const RequestEntity({
    required this.id,
    required this.clientId,
    required this.providerId,
    required this.serviceId,
    required this.title,
    required this.description,
    this.location,
    this.preferredDate,
    this.budgetFrom,
    this.budgetTo,
    required this.status,
    this.providerResponse,
    required this.createdAt,
    this.updatedAt,
  });

  /// Obtener texto legible del estado
  String get statusText {
    return switch (status) {
      RequestStatus.pending => 'Pendiente',
      RequestStatus.accepted => 'Aceptada',
      RequestStatus.rejected => 'Rechazada',
      RequestStatus.inProgress => 'En Progreso',
      RequestStatus.completed => 'Completada',
      RequestStatus.cancelled => 'Cancelada',
    };
  }

  /// Obtener color del estado
  String get statusColor {
    return switch (status) {
      RequestStatus.pending => 'warning',
      RequestStatus.accepted => 'success',
      RequestStatus.rejected => 'error',
      RequestStatus.inProgress => 'info',
      RequestStatus.completed => 'success',
      RequestStatus.cancelled => 'grey',
    };
  }

  /// Verificar si puede ser cancelada
  bool get canBeCancelled {
    return status == RequestStatus.pending || status == RequestStatus.accepted;
  }

  /// Verificar si puede ser aceptada/rechazada
  bool get canBeResponded {
    return status == RequestStatus.pending;
  }

  /// Verificar si puede marcarse como completada
  bool get canBeCompleted {
    return status == RequestStatus.inProgress;
  }

  RequestEntity copyWith({
    String? id,
    String? clientId,
    String? providerId,
    String? serviceId,
    String? title,
    String? description,
    String? location,
    DateTime? preferredDate,
    double? budgetFrom,
    double? budgetTo,
    RequestStatus? status,
    String? providerResponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RequestEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
      serviceId: serviceId ?? this.serviceId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      preferredDate: preferredDate ?? this.preferredDate,
      budgetFrom: budgetFrom ?? this.budgetFrom,
      budgetTo: budgetTo ?? this.budgetTo,
      status: status ?? this.status,
      providerResponse: providerResponse ?? this.providerResponse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        providerId,
        serviceId,
        title,
        description,
        location,
        preferredDate,
        budgetFrom,
        budgetTo,
        status,
        providerResponse,
        createdAt,
        updatedAt,
      ];
}

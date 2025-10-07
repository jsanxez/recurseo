import 'package:recurseo/features/requests/domain/entities/request_entity.dart';

/// Modelo de solicitud para serialización
class RequestModel extends RequestEntity {
  const RequestModel({
    required super.id,
    required super.clientId,
    required super.providerId,
    required super.serviceId,
    required super.title,
    required super.description,
    super.location,
    super.preferredDate,
    super.budgetFrom,
    super.budgetTo,
    required super.status,
    super.providerResponse,
    required super.createdAt,
    super.updatedAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      providerId: json['provider_id'] as String,
      serviceId: json['service_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String?,
      preferredDate: json['preferred_date'] != null
          ? DateTime.parse(json['preferred_date'] as String)
          : null,
      budgetFrom: json['budget_from'] != null
          ? (json['budget_from'] as num).toDouble()
          : null,
      budgetTo: json['budget_to'] != null
          ? (json['budget_to'] as num).toDouble()
          : null,
      status: _parseStatus(json['status'] as String),
      providerResponse: json['provider_response'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'provider_id': providerId,
      'service_id': serviceId,
      'title': title,
      'description': description,
      'location': location,
      'preferred_date': preferredDate?.toIso8601String(),
      'budget_from': budgetFrom,
      'budget_to': budgetTo,
      'status': _statusToString(status),
      'provider_response': providerResponse,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory RequestModel.fromEntity(RequestEntity entity) {
    return RequestModel(
      id: entity.id,
      clientId: entity.clientId,
      providerId: entity.providerId,
      serviceId: entity.serviceId,
      title: entity.title,
      description: entity.description,
      location: entity.location,
      preferredDate: entity.preferredDate,
      budgetFrom: entity.budgetFrom,
      budgetTo: entity.budgetTo,
      status: entity.status,
      providerResponse: entity.providerResponse,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static RequestStatus _parseStatus(String status) {
    return switch (status.toLowerCase()) {
      'pending' => RequestStatus.pending,
      'accepted' => RequestStatus.accepted,
      'rejected' => RequestStatus.rejected,
      'in_progress' => RequestStatus.inProgress,
      'completed' => RequestStatus.completed,
      'cancelled' => RequestStatus.cancelled,
      _ => RequestStatus.pending,
    };
  }

  static String _statusToString(RequestStatus status) {
    return switch (status) {
      RequestStatus.pending => 'pending',
      RequestStatus.accepted => 'accepted',
      RequestStatus.rejected => 'rejected',
      RequestStatus.inProgress => 'in_progress',
      RequestStatus.completed => 'completed',
      RequestStatus.cancelled => 'cancelled',
    };
  }
}

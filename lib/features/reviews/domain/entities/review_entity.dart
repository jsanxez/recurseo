import 'package:equatable/equatable.dart';

/// Entidad de reseña de un servicio
class ReviewEntity extends Equatable {
  final String id;
  final String serviceId;
  final String clientId;
  final String clientName;
  final String? clientPhotoUrl;
  final String providerId;
  final int rating; // 1-5 estrellas
  final String comment;
  final bool isVerified; // Si la reseña es de un trabajo completado
  final String? requestId; // ID de la solicitud relacionada
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ReviewEntity({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.clientName,
    this.clientPhotoUrl,
    required this.providerId,
    required this.rating,
    required this.comment,
    this.isVerified = false,
    this.requestId,
    required this.createdAt,
    this.updatedAt,
  });

  /// Verificar si es una reseña positiva (4-5 estrellas)
  bool get isPositive => rating >= 4;

  /// Obtener tiempo relativo desde la creación
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return 'Hace $years ${years == 1 ? "año" : "años"}';
    } else if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? "mes" : "meses"}';
    } else if (diff.inDays > 0) {
      return 'Hace ${diff.inDays} ${diff.inDays == 1 ? "día" : "días"}';
    } else if (diff.inHours > 0) {
      return 'Hace ${diff.inHours} ${diff.inHours == 1 ? "hora" : "horas"}';
    } else if (diff.inMinutes > 0) {
      return 'Hace ${diff.inMinutes} ${diff.inMinutes == 1 ? "minuto" : "minutos"}';
    } else {
      return 'Hace un momento';
    }
  }

  ReviewEntity copyWith({
    String? id,
    String? serviceId,
    String? clientId,
    String? clientName,
    String? clientPhotoUrl,
    String? providerId,
    int? rating,
    String? comment,
    bool? isVerified,
    String? requestId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhotoUrl: clientPhotoUrl ?? this.clientPhotoUrl,
      providerId: providerId ?? this.providerId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isVerified: isVerified ?? this.isVerified,
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceId,
        clientId,
        clientName,
        clientPhotoUrl,
        providerId,
        rating,
        comment,
        isVerified,
        requestId,
        createdAt,
        updatedAt,
      ];
}

import 'package:equatable/equatable.dart';

/// Estado de una propuesta
enum ProposalStatus {
  pending, // Pendiente de revisión por el cliente
  accepted, // Aceptada por el cliente
  rejected, // Rechazada por el cliente
  withdrawn, // Retirada por el profesional
}

/// Entidad de propuesta/cotización
///
/// Representa la propuesta que un profesional envía a una oferta de trabajo
/// publicada por un cliente.
class ProposalEntity extends Equatable {
  /// ID único de la propuesta
  final String id;

  /// ID de la oferta de trabajo a la que responde
  final String jobPostId;

  /// ID del profesional que envía la propuesta
  final String professionalId;

  /// Nombre del profesional
  final String professionalName;

  /// URL de foto del profesional
  final String? professionalPhotoUrl;

  /// Mensaje de presentación del profesional
  final String message;

  /// Tarifa propuesta por el profesional
  final double proposedRate;

  /// Tipo de pago propuesto (debe coincidir con el tipo del JobPost)
  /// Incluido aquí para referencia rápida
  final String rateType; // 'por_dia', 'por_hora', 'por_proyecto'

  /// Fecha desde cuándo puede empezar
  final DateTime availableFrom;

  /// Duración estimada en días (opcional)
  final int? estimatedDays;

  /// URLs de fotos del portfolio (trabajos previos similares)
  final List<String> portfolioUrls;

  /// Estado de la propuesta
  final ProposalStatus status;

  /// Fecha de creación de la propuesta
  final DateTime createdAt;

  /// Fecha de actualización
  final DateTime? updatedAt;

  /// Razón de rechazo (si fue rechazada)
  final String? rejectionReason;

  const ProposalEntity({
    required this.id,
    required this.jobPostId,
    required this.professionalId,
    required this.professionalName,
    this.professionalPhotoUrl,
    required this.message,
    required this.proposedRate,
    required this.rateType,
    required this.availableFrom,
    this.estimatedDays,
    this.portfolioUrls = const [],
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.rejectionReason,
  });

  /// Obtener texto legible del estado
  String get statusText {
    return switch (status) {
      ProposalStatus.pending => 'Pendiente',
      ProposalStatus.accepted => 'Aceptada',
      ProposalStatus.rejected => 'Rechazada',
      ProposalStatus.withdrawn => 'Retirada',
    };
  }

  /// Obtener tarifa formateada
  String get formattedRate {
    final typeText = switch (rateType) {
      'por_dia' => '/día',
      'por_hora' => '/hora',
      'por_proyecto' => ' por proyecto',
      _ => '',
    };
    return '\$${proposedRate.toStringAsFixed(0)}$typeText';
  }

  /// Verificar si está pendiente
  bool get isPending {
    return status == ProposalStatus.pending;
  }

  /// Verificar si fue aceptada
  bool get isAccepted {
    return status == ProposalStatus.accepted;
  }

  /// Verificar si fue rechazada
  bool get isRejected {
    return status == ProposalStatus.rejected;
  }

  /// Verificar si fue retirada
  bool get isWithdrawn {
    return status == ProposalStatus.withdrawn;
  }

  /// Días hasta que puede empezar
  int get daysUntilAvailable {
    final diff = availableFrom.difference(DateTime.now());
    return diff.inDays >= 0 ? diff.inDays : 0;
  }

  /// Verificar si puede empezar inmediatamente (hoy o mañana)
  bool get canStartImmediately {
    return daysUntilAvailable <= 1;
  }

  ProposalEntity copyWith({
    String? id,
    String? jobPostId,
    String? professionalId,
    String? professionalName,
    String? professionalPhotoUrl,
    String? message,
    double? proposedRate,
    String? rateType,
    DateTime? availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
    ProposalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? rejectionReason,
  }) {
    return ProposalEntity(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      professionalId: professionalId ?? this.professionalId,
      professionalName: professionalName ?? this.professionalName,
      professionalPhotoUrl: professionalPhotoUrl ?? this.professionalPhotoUrl,
      message: message ?? this.message,
      proposedRate: proposedRate ?? this.proposedRate,
      rateType: rateType ?? this.rateType,
      availableFrom: availableFrom ?? this.availableFrom,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobPostId,
        professionalId,
        professionalName,
        professionalPhotoUrl,
        message,
        proposedRate,
        rateType,
        availableFrom,
        estimatedDays,
        portfolioUrls,
        status,
        createdAt,
        updatedAt,
        rejectionReason,
      ];
}

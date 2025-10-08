import 'package:equatable/equatable.dart';

/// Tipo de trabajo
enum JobType {
  temporal, // Trabajo temporal (X días/semanas)
  permanente, // Trabajo a largo plazo
  porProyecto, // Proyecto específico con fecha fin
}

/// Tipo de pago
enum PaymentType {
  porDia, // Pago diario
  porHora, // Pago por hora
  porProyecto, // Pago total por proyecto completo
}

/// Nivel de urgencia
enum UrgencyLevel {
  urgente, // Necesita empezar hoy/mañana
  normal, // Puede esperar algunos días
  flexible, // Fechas flexibles
}

/// Estado de la oferta de trabajo
enum JobPostStatus {
  open, // Abierta, recibiendo propuestas
  inReview, // Cliente revisando propuestas
  closed, // Cerrada, no acepta más propuestas
  filled, // Cupo completo, trabajo asignado
  cancelled, // Cancelada por el cliente
}

/// Entidad de publicación de trabajo/oferta laboral
///
/// Representa una oferta de trabajo publicada por un cliente
/// que busca contratar profesionales para un proyecto o tarea.
class JobPostEntity extends Equatable {
  /// ID único de la oferta
  final String id;

  /// ID del cliente que publica la oferta
  final String clientId;

  /// Categorías del trabajo (puede ser múltiple: electricidad + plomería)
  final List<String> categoryIds;

  /// Título de la oferta
  final String title;

  /// Descripción detallada del trabajo
  final String description;

  /// Ubicación del trabajo
  final String location;

  /// Tipo de trabajo
  final JobType type;

  /// Duración estimada en días (opcional)
  final int? durationDays;

  /// Tipo de pago
  final PaymentType paymentType;

  /// Presupuesto mínimo
  final double? budgetMin;

  /// Presupuesto máximo
  final double? budgetMax;

  /// Nivel de urgencia
  final UrgencyLevel urgency;

  /// Cantidad de trabajadores requeridos
  final int requiredWorkers;

  /// Requisitos específicos (experiencia, herramientas, etc.)
  final List<String> requirements;

  /// URLs de fotos del proyecto/lugar
  final List<String> photoUrls;

  /// Estado de la oferta
  final JobPostStatus status;

  /// Fecha de creación
  final DateTime createdAt;

  /// Fecha de actualización
  final DateTime? updatedAt;

  /// Fecha de expiración (ofertas expiran automáticamente)
  final DateTime expiresAt;

  /// Cantidad de propuestas recibidas
  final int proposalsCount;

  const JobPostEntity({
    required this.id,
    required this.clientId,
    required this.categoryIds,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    this.durationDays,
    required this.paymentType,
    this.budgetMin,
    this.budgetMax,
    required this.urgency,
    this.requiredWorkers = 1,
    this.requirements = const [],
    this.photoUrls = const [],
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.expiresAt,
    this.proposalsCount = 0,
  });

  /// Obtener texto legible del tipo de trabajo
  String get typeText {
    return switch (type) {
      JobType.temporal => 'Temporal',
      JobType.permanente => 'Permanente',
      JobType.porProyecto => 'Por Proyecto',
    };
  }

  /// Obtener texto legible del tipo de pago
  String get paymentTypeText {
    return switch (paymentType) {
      PaymentType.porDia => 'Por día',
      PaymentType.porHora => 'Por hora',
      PaymentType.porProyecto => 'Por proyecto',
    };
  }

  /// Obtener texto legible del nivel de urgencia
  String get urgencyText {
    return switch (urgency) {
      UrgencyLevel.urgente => 'Urgente',
      UrgencyLevel.normal => 'Normal',
      UrgencyLevel.flexible => 'Flexible',
    };
  }

  /// Obtener texto legible del estado
  String get statusText {
    return switch (status) {
      JobPostStatus.open => 'Abierta',
      JobPostStatus.inReview => 'En Revisión',
      JobPostStatus.closed => 'Cerrada',
      JobPostStatus.filled => 'Cubierta',
      JobPostStatus.cancelled => 'Cancelada',
    };
  }

  /// Obtener rango de presupuesto formateado
  String get budgetRange {
    if (budgetMin == null && budgetMax == null) {
      return 'A consultar';
    }

    final unit = ' ${paymentTypeText.toLowerCase()}';

    if (budgetMin != null && budgetMax != null) {
      return '\$${budgetMin!.toStringAsFixed(0)} - \$${budgetMax!.toStringAsFixed(0)}$unit';
    } else if (budgetMin != null) {
      return 'Desde \$${budgetMin!.toStringAsFixed(0)}$unit';
    } else {
      return 'Hasta \$${budgetMax!.toStringAsFixed(0)}$unit';
    }
  }

  /// Verificar si la oferta está activa (acepta propuestas)
  bool get isActive {
    return status == JobPostStatus.open && !isExpired;
  }

  /// Verificar si la oferta expiró
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Verificar si es urgente
  bool get isUrgent {
    return urgency == UrgencyLevel.urgente;
  }

  /// Días restantes hasta expiración
  int get daysUntilExpiration {
    final diff = expiresAt.difference(DateTime.now());
    return diff.inDays;
  }

  JobPostEntity copyWith({
    String? id,
    String? clientId,
    List<String>? categoryIds,
    String? title,
    String? description,
    String? location,
    JobType? type,
    int? durationDays,
    PaymentType? paymentType,
    double? budgetMin,
    double? budgetMax,
    UrgencyLevel? urgency,
    int? requiredWorkers,
    List<String>? requirements,
    List<String>? photoUrls,
    JobPostStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    int? proposalsCount,
  }) {
    return JobPostEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      categoryIds: categoryIds ?? this.categoryIds,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      durationDays: durationDays ?? this.durationDays,
      paymentType: paymentType ?? this.paymentType,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      urgency: urgency ?? this.urgency,
      requiredWorkers: requiredWorkers ?? this.requiredWorkers,
      requirements: requirements ?? this.requirements,
      photoUrls: photoUrls ?? this.photoUrls,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      proposalsCount: proposalsCount ?? this.proposalsCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        categoryIds,
        title,
        description,
        location,
        type,
        durationDays,
        paymentType,
        budgetMin,
        budgetMax,
        urgency,
        requiredWorkers,
        requirements,
        photoUrls,
        status,
        createdAt,
        updatedAt,
        expiresAt,
        proposalsCount,
      ];
}

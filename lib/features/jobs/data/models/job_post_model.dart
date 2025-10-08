import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';

/// Modelo de datos para JobPost (serialización)
class JobPostModel extends JobPostEntity {
  const JobPostModel({
    required super.id,
    required super.clientId,
    required super.categoryIds,
    required super.title,
    required super.description,
    required super.location,
    required super.type,
    super.durationDays,
    required super.paymentType,
    super.budgetMin,
    super.budgetMax,
    required super.urgency,
    super.requiredWorkers,
    super.requirements,
    super.photoUrls,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    required super.expiresAt,
    super.proposalsCount,
  });

  /// Crear desde JSON
  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      categoryIds: (json['category_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      type: JobType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => JobType.temporal,
      ),
      durationDays: json['duration_days'] as int?,
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == json['payment_type'],
        orElse: () => PaymentType.porDia,
      ),
      budgetMin: json['budget_min'] != null
          ? (json['budget_min'] as num).toDouble()
          : null,
      budgetMax: json['budget_max'] != null
          ? (json['budget_max'] as num).toDouble()
          : null,
      urgency: UrgencyLevel.values.firstWhere(
        (e) => e.name == json['urgency'],
        orElse: () => UrgencyLevel.normal,
      ),
      requiredWorkers: json['required_workers'] as int? ?? 1,
      requirements: json['requirements'] != null
          ? (json['requirements'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      photoUrls: json['photo_urls'] != null
          ? (json['photo_urls'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      status: JobPostStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => JobPostStatus.open,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      proposalsCount: json['proposals_count'] as int? ?? 0,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'category_ids': categoryIds,
      'title': title,
      'description': description,
      'location': location,
      'type': type.name,
      'duration_days': durationDays,
      'payment_type': paymentType.name,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'urgency': urgency.name,
      'required_workers': requiredWorkers,
      'requirements': requirements,
      'photo_urls': photoUrls,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'proposals_count': proposalsCount,
    };
  }

  /// Crear desde entidad
  factory JobPostModel.fromEntity(JobPostEntity entity) {
    return JobPostModel(
      id: entity.id,
      clientId: entity.clientId,
      categoryIds: entity.categoryIds,
      title: entity.title,
      description: entity.description,
      location: entity.location,
      type: entity.type,
      durationDays: entity.durationDays,
      paymentType: entity.paymentType,
      budgetMin: entity.budgetMin,
      budgetMax: entity.budgetMax,
      urgency: entity.urgency,
      requiredWorkers: entity.requiredWorkers,
      requirements: entity.requirements,
      photoUrls: entity.photoUrls,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      expiresAt: entity.expiresAt,
      proposalsCount: entity.proposalsCount,
    );
  }

  /// Copiar con nuevos valores
  JobPostModel copyWith({
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
    return JobPostModel(
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
}

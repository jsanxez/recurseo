import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';

/// Modelo de datos para Proposal (serialización)
class ProposalModel extends ProposalEntity {
  const ProposalModel({
    required super.id,
    required super.jobPostId,
    required super.professionalId,
    required super.professionalName,
    super.professionalPhotoUrl,
    required super.message,
    required super.proposedRate,
    required super.rateType,
    required super.availableFrom,
    super.estimatedDays,
    super.portfolioUrls,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.rejectionReason,
  });

  /// Crear desde JSON
  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] as String,
      jobPostId: json['job_post_id'] as String,
      professionalId: json['professional_id'] as String,
      professionalName: json['professional_name'] as String,
      professionalPhotoUrl: json['professional_photo_url'] as String?,
      message: json['message'] as String,
      proposedRate: (json['proposed_rate'] as num).toDouble(),
      rateType: json['rate_type'] as String,
      availableFrom: DateTime.parse(json['available_from'] as String),
      estimatedDays: json['estimated_days'] as int?,
      portfolioUrls: json['portfolio_urls'] != null
          ? (json['portfolio_urls'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      status: ProposalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProposalStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_id': jobPostId,
      'professional_id': professionalId,
      'professional_name': professionalName,
      'professional_photo_url': professionalPhotoUrl,
      'message': message,
      'proposed_rate': proposedRate,
      'rate_type': rateType,
      'available_from': availableFrom.toIso8601String(),
      'estimated_days': estimatedDays,
      'portfolio_urls': portfolioUrls,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
    };
  }

  /// Crear desde entidad
  factory ProposalModel.fromEntity(ProposalEntity entity) {
    return ProposalModel(
      id: entity.id,
      jobPostId: entity.jobPostId,
      professionalId: entity.professionalId,
      professionalName: entity.professionalName,
      professionalPhotoUrl: entity.professionalPhotoUrl,
      message: entity.message,
      proposedRate: entity.proposedRate,
      rateType: entity.rateType,
      availableFrom: entity.availableFrom,
      estimatedDays: entity.estimatedDays,
      portfolioUrls: entity.portfolioUrls,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      rejectionReason: entity.rejectionReason,
    );
  }

  /// Copiar con nuevos valores
  ProposalModel copyWith({
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
    return ProposalModel(
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
}

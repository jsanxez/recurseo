import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';

/// Modelo de datos para Proposal (serialización)
class ProposalModel extends ProposalEntity {
  const ProposalModel({
    required super.id,
    required super.jobPostId,
    super.jobTitle,
    required super.professionalId,
    required super.professionalName,
    super.professionalPhotoUrl,
    required super.message,
    required super.proposedRate,
    required super.rateType,
    required super.availableFrom,
    super.estimatedDays,
    super.portfolioUrls,
    super.yearsExperience,
    super.estimatedDuration,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.acceptedAt,
    super.rejectedAt,
    super.withdrawnAt,
    super.rejectionReason,
  });

  /// Crear desde JSON
  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] as String,
      jobPostId: json['job_post_id'] as String,
      jobTitle: json['job_title'] as String?,
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
      yearsExperience: json['years_experience'] as int?,
      estimatedDuration: json['estimated_duration'] as String?,
      status: ProposalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProposalStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.parse(json['rejected_at'] as String)
          : null,
      withdrawnAt: json['withdrawn_at'] != null
          ? DateTime.parse(json['withdrawn_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_id': jobPostId,
      'job_title': jobTitle,
      'professional_id': professionalId,
      'professional_name': professionalName,
      'professional_photo_url': professionalPhotoUrl,
      'message': message,
      'proposed_rate': proposedRate,
      'rate_type': rateType,
      'available_from': availableFrom.toIso8601String(),
      'estimated_days': estimatedDays,
      'portfolio_urls': portfolioUrls,
      'years_experience': yearsExperience,
      'estimated_duration': estimatedDuration,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'withdrawn_at': withdrawnAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
    };
  }

  /// Crear desde entidad
  factory ProposalModel.fromEntity(ProposalEntity entity) {
    return ProposalModel(
      id: entity.id,
      jobPostId: entity.jobPostId,
      jobTitle: entity.jobTitle,
      professionalId: entity.professionalId,
      professionalName: entity.professionalName,
      professionalPhotoUrl: entity.professionalPhotoUrl,
      message: entity.message,
      proposedRate: entity.proposedRate,
      rateType: entity.rateType,
      availableFrom: entity.availableFrom,
      estimatedDays: entity.estimatedDays,
      portfolioUrls: entity.portfolioUrls,
      yearsExperience: entity.yearsExperience,
      estimatedDuration: entity.estimatedDuration,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      acceptedAt: entity.acceptedAt,
      rejectedAt: entity.rejectedAt,
      withdrawnAt: entity.withdrawnAt,
      rejectionReason: entity.rejectionReason,
    );
  }

  /// Copiar con nuevos valores
  @override
  ProposalModel copyWith({
    String? id,
    String? jobPostId,
    String? jobTitle,
    String? professionalId,
    String? professionalName,
    String? professionalPhotoUrl,
    String? message,
    double? proposedRate,
    String? rateType,
    DateTime? availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
    int? yearsExperience,
    String? estimatedDuration,
    ProposalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    DateTime? withdrawnAt,
    String? rejectionReason,
  }) {
    return ProposalModel(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      jobTitle: jobTitle ?? this.jobTitle,
      professionalId: professionalId ?? this.professionalId,
      professionalName: professionalName ?? this.professionalName,
      professionalPhotoUrl: professionalPhotoUrl ?? this.professionalPhotoUrl,
      message: message ?? this.message,
      proposedRate: proposedRate ?? this.proposedRate,
      rateType: rateType ?? this.rateType,
      availableFrom: availableFrom ?? this.availableFrom,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      withdrawnAt: withdrawnAt ?? this.withdrawnAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

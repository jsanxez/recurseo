import 'package:recurseo/features/profile/domain/entities/service_entity.dart';

/// Modelo de servicio para serialización
class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.providerId,
    required super.categoryId,
    required super.title,
    required super.description,
    super.priceFrom,
    super.priceTo,
    super.priceUnit,
    required super.photoUrls,
    required super.isActive,
    required super.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priceFrom: json['price_from'] != null
          ? (json['price_from'] as num).toDouble()
          : null,
      priceTo: json['price_to'] != null
          ? (json['price_to'] as num).toDouble()
          : null,
      priceUnit: json['price_unit'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price_from': priceFrom,
      'price_to': priceTo,
      'price_unit': priceUnit,
      'photo_urls': photoUrls,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      providerId: entity.providerId,
      categoryId: entity.categoryId,
      title: entity.title,
      description: entity.description,
      priceFrom: entity.priceFrom,
      priceTo: entity.priceTo,
      priceUnit: entity.priceUnit,
      photoUrls: entity.photoUrls,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}

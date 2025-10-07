import 'package:recurseo/features/services/domain/entities/category_entity.dart';

/// Modelo de categoría para serialización
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconName,
    super.imageUrl,
    required super.servicesCount,
    required super.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['icon_name'] as String,
      imageUrl: json['image_url'] as String?,
      servicesCount: json['services_count'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_name': iconName,
      'image_url': imageUrl,
      'services_count': servicesCount,
      'is_active': isActive,
    };
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconName: entity.iconName,
      imageUrl: entity.imageUrl,
      servicesCount: entity.servicesCount,
      isActive: entity.isActive,
    );
  }
}

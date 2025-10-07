import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entidad de categoría de servicios
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String? imageUrl;
  final int servicesCount;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.imageUrl,
    required this.servicesCount,
    required this.isActive,
  });

  /// Obtener icono de Material Icons
  IconData get icon {
    return switch (iconName) {
      'build' => Icons.build,
      'cleaning_services' => Icons.cleaning_services,
      'electrical_services' => Icons.electrical_services,
      'plumbing' => Icons.plumbing,
      'format_paint' => Icons.format_paint,
      'computer' => Icons.computer,
      'local_shipping' => Icons.local_shipping,
      'home_repair_service' => Icons.home_repair_service,
      'yard' => Icons.yard,
      'school' => Icons.school,
      'fitness_center' => Icons.fitness_center,
      'restaurant' => Icons.restaurant,
      'camera_alt' => Icons.camera_alt,
      'event' => Icons.event,
      'spa' => Icons.spa,
      _ => Icons.category,
    };
  }

  /// Obtener color sugerido
  Color get color {
    return switch (iconName) {
      'build' => Colors.blue,
      'cleaning_services' => Colors.green,
      'electrical_services' => Colors.orange,
      'plumbing' => Colors.red,
      'format_paint' => Colors.purple,
      'computer' => Colors.teal,
      'local_shipping' => Colors.indigo,
      'home_repair_service' => Colors.brown,
      'yard' => Colors.lightGreen,
      'school' => Colors.deepPurple,
      'fitness_center' => Colors.pink,
      'restaurant' => Colors.amber,
      'camera_alt' => Colors.cyan,
      'event' => Colors.lime,
      'spa' => Colors.lightBlue,
      _ => Colors.grey,
    };
  }

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? imageUrl,
    int? servicesCount,
    bool? isActive,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      imageUrl: imageUrl ?? this.imageUrl,
      servicesCount: servicesCount ?? this.servicesCount,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconName,
        imageUrl,
        servicesCount,
        isActive,
      ];
}

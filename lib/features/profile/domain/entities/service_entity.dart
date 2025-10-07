import 'package:equatable/equatable.dart';

/// Entidad de servicio ofrecido por un proveedor
class ServiceEntity extends Equatable {
  final String id;
  final String providerId;
  final String categoryId;
  final String title;
  final String description;
  final double? priceFrom;
  final double? priceTo;
  final String? priceUnit; // 'hour', 'job', 'day'
  final List<String> photoUrls;
  final bool isActive;
  final DateTime createdAt;

  const ServiceEntity({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.description,
    this.priceFrom,
    this.priceTo,
    this.priceUnit,
    required this.photoUrls,
    required this.isActive,
    required this.createdAt,
  });

  /// Obtener rango de precio formateado
  String get priceRange {
    if (priceFrom == null && priceTo == null) {
      return 'Precio a consultar';
    }

    final unit = _formatPriceUnit();

    if (priceFrom != null && priceTo != null) {
      return '\$${priceFrom!.toStringAsFixed(0)} - \$${priceTo!.toStringAsFixed(0)}$unit';
    } else if (priceFrom != null) {
      return 'Desde \$${priceFrom!.toStringAsFixed(0)}$unit';
    } else {
      return 'Hasta \$${priceTo!.toStringAsFixed(0)}$unit';
    }
  }

  String _formatPriceUnit() {
    return switch (priceUnit) {
      'hour' => '/hora',
      'day' => '/día',
      'job' => '/trabajo',
      _ => '',
    };
  }

  ServiceEntity copyWith({
    String? id,
    String? providerId,
    String? categoryId,
    String? title,
    String? description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
    List<String>? photoUrls,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      priceUnit: priceUnit ?? this.priceUnit,
      photoUrls: photoUrls ?? this.photoUrls,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        providerId,
        categoryId,
        title,
        description,
        priceFrom,
        priceTo,
        priceUnit,
        photoUrls,
        isActive,
        createdAt,
      ];
}

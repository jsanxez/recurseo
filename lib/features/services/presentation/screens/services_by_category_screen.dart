import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/services/presentation/providers/catalog_providers.dart';

/// Pantalla de servicios por categoría
class ServicesByCategoryScreen extends ConsumerWidget {
  final String categoryId;

  const ServicesByCategoryScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesByCategoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Abrir búsqueda
            },
          ),
        ],
      ),
      body: servicesAsync.when(
        data: (services) {
          if (services.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: AppColors.grey300),
                  SizedBox(height: AppSizes.paddingMd),
                  Text('No hay servicios en esta categoría'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                child: InkWell(
                  onTap: () {
                    context.push('/services/${service.id}');
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: service.photoUrls.isNotEmpty
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radiusSm),
                                  child: Image.network(
                                    service.photoUrls.first,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.image,
                                  color: AppColors.grey400),
                        ),
                        const SizedBox(width: AppSizes.paddingMd),

                        // Información
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSizes.paddingXs),
                              Text(
                                service.description,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSizes.paddingSm),
                              Row(
                                children: [
                                  Text(
                                    service.priceRange,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.star,
                                      size: 16, color: AppColors.warning),
                                  const Text(' 4.5'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: AppColors.error),
              const SizedBox(height: AppSizes.paddingMd),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

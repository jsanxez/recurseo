import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/services/presentation/providers/catalog_providers.dart';

/// Pantalla de detalle de un servicio
class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(serviceByIdProvider(serviceId));

    return Scaffold(
      body: serviceAsync.when(
        data: (service) => CustomScrollView(
          slivers: [
            // AppBar con imagen
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(service.title),
                background: service.photoUrls.isNotEmpty
                    ? Image.network(service.photoUrls.first, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.primaryLight,
                        child: const Icon(Icons.image, size: 80, color: Colors.white),
                      ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // TODO: Toggle favorite
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Share
                  },
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Precio
                  Card(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Precio',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            service.priceRange,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingLg),

                  // Descripción
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.paddingSm),
                  Text(service.description),
                  const SizedBox(height: AppSizes.paddingLg),

                  // Proveedor
                  Text(
                    'Proveedor',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.paddingMd),
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: const Text('Nombre del Proveedor'),
                      subtitle: const Row(
                        children: [
                          Icon(Icons.star, size: 16, color: AppColors.warning),
                          Text(' 4.8 (45 reviews)'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.push('/profile/provider/${service.providerId}');
                      },
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXl),

                  // Botón de solicitar
                  FilledButton.icon(
                    onPressed: () {
                      context.push(
                        '/requests/create/${service.providerId}/${service.id}',
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Solicitar Servicio'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingMd),

                  // Botón de contactar
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Abrir chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidad próximamente'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Contactar Proveedor'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppSizes.paddingMd),
              Text('Error: $error'),
              const SizedBox(height: AppSizes.paddingMd),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

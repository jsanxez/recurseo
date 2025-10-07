import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';

/// Pantalla de perfil público del proveedor (vista para clientes)
class ProviderPublicProfileScreen extends ConsumerWidget {
  final String providerId;

  const ProviderPublicProfileScreen({
    super.key,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Cargar datos del proveedor desde el provider
    // final providerProfile = ref.watch(providerProfileProvider(providerId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen de fondo
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Nombre del Proveedor'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.store,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header con rating y stats
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.star,
                        value: '4.8',
                        label: 'Rating',
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingMd),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle,
                        value: '127',
                        label: 'Trabajos',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingMd),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.rate_review,
                        value: '45',
                        label: 'Reviews',
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingLg),

                // Badge de verificado
                if (true) // isVerified
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: AppColors.success, size: 16),
                        SizedBox(width: AppSizes.paddingSm),
                        Text(
                          'Proveedor Verificado',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSizes.paddingLg),

                // Descripción
                Text(
                  'Acerca de',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.paddingSm),
                const Text(
                  'Soy un profesional con más de 10 años de experiencia en el rubro. Ofrezco servicios de calidad con garantía. Trabajo con materiales de primera y cuento con todas las herramientas necesarias.',
                ),
                const SizedBox(height: AppSizes.paddingLg),

                // Servicios
                Text(
                  'Servicios Ofrecidos',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.paddingMd),
                ..._buildServiceCards(),
                const SizedBox(height: AppSizes.paddingLg),

                // Portfolio
                Text(
                  'Portfolio',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.paddingMd),
                _buildPortfolioGrid(),
                const SizedBox(height: AppSizes.paddingLg),

                // Reviews (placeholder)
                Text(
                  'Reseñas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.paddingMd),
                _buildReviewsList(),
                const SizedBox(height: AppSizes.paddingXl),

                // Botón de contacto
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Ir a crear solicitud
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Solicitar Servicio'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildServiceCards() {
    // Placeholder services
    final services = [
      {'title': 'Instalación Eléctrica', 'price': '\$500 - \$1,500'},
      {'title': 'Reparación de Enchufes', 'price': '\$200 - \$400'},
      {'title': 'Mantenimiento General', 'price': '\$300/visita'},
    ];

    return services
        .map((service) => Card(
              margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.build, color: Colors.white),
                ),
                title: Text(service['title']!),
                subtitle: Text(service['price']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Ver detalle del servicio
                },
              ),
            ))
        .toList();
  }

  Widget _buildPortfolioGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSizes.paddingSm,
        mainAxisSpacing: AppSizes.paddingSm,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Icon(Icons.image, color: AppColors.grey400, size: 32),
        );
      },
    );
  }

  Widget _buildReviewsList() {
    return Column(
      children: List.generate(3, (index) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: AppSizes.paddingSm),
                    const Expanded(
                      child: Text(
                        'Cliente Demo',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppColors.warning),
                        Text(' 5.0'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingSm),
                const Text(
                  'Excelente servicio, muy profesional y puntual. Lo recomiendo ampliamente.',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Widget para mostrar estadísticas
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSizes.paddingSm),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

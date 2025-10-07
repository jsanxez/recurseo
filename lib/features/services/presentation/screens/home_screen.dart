import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';

/// Pantalla principal de la aplicación
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const _RequestsTab(),
    const _MessagesTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Solicitudes',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Mensajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Tab de Inicio
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Recurseo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Buscador
              _SearchBar(),
              const SizedBox(height: AppSizes.paddingLg),

              // Categorías populares
              Text(
                'Categorías Populares',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              _CategoriesGrid(),
              const SizedBox(height: AppSizes.paddingLg),

              // Servicios destacados
              Text(
                'Servicios Destacados',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              _ServicesList(),
            ]),
          ),
        ),
      ],
    );
  }
}

// Buscador
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: '¿Qué servicio necesitas?',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () {},
        ),
      ),
    );
  }
}

// Grid de categorías
class _CategoriesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.build, 'name': 'Reparaciones', 'color': Colors.blue},
    {'icon': Icons.cleaning_services, 'name': 'Limpieza', 'color': Colors.green},
    {'icon': Icons.electrical_services, 'name': 'Electricidad', 'color': Colors.orange},
    {'icon': Icons.plumbing, 'name': 'Plomería', 'color': Colors.red},
    {'icon': Icons.format_paint, 'name': 'Pintura', 'color': Colors.purple},
    {'icon': Icons.computer, 'name': 'Tecnología', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSizes.paddingMd,
        mainAxisSpacing: AppSizes.paddingMd,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'],
                  size: 32,
                  color: category['color'],
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Text(
                  category['name'],
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Lista de servicios
class _ServicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Servicio de ejemplo ${index + 1}'),
            subtitle: Text('Categoría • ⭐ 4.${5 + index}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }
}

// Tab de Solicitudes
class _RequestsTab extends StatelessWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Mis Solicitudes'),
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Solicitud #${1000 + index}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Chip(
                              label: const Text('Pendiente'),
                              backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingSm),
                        const Text('Reparación de tubería'),
                        const SizedBox(height: AppSizes.paddingSm),
                        Text(
                          'Hace 2 horas',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }
}

// Tab de Mensajes
class _MessagesTab extends StatelessWidget {
  const _MessagesTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Mensajes'),
          floating: true,
        ),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppColors.grey300,
                ),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  'No tienes mensajes aún',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Tab de Perfil
class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Perfil'),
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header del perfil
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    Text(
                      user?.name ?? 'Usuario',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      user?.email ?? 'usuario@email.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingXl),

              // Opciones
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Editar perfil'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.work_outline),
                      title: const Text('Ser proveedor'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Configuración'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Ayuda'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Acerca de'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              // Botón de cerrar sesión
              OutlinedButton.icon(
                onPressed: () async {
                  // Mostrar confirmación
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: const Text('Cerrar Sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    ref.read(authNotifierProvider.notifier).logout();
                    context.go('/welcome');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

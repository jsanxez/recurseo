import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/jobs/domain/repositories/job_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_feed_provider.dart';
import 'package:recurseo/features/jobs/presentation/widgets/empty_state.dart';
import 'package:recurseo/features/jobs/presentation/widgets/job_card.dart';

/// Pantalla principal con feed de ofertas de trabajo
class JobFeedScreen extends ConsumerWidget {
  const JobFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobFeedProvider);
    final notifier = ref.read(jobFeedProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);
    final isClient = currentUser?.userType == UserType.client;
    final isProvider = currentUser?.userType == UserType.provider;

    return Scaffold(
      appBar: AppBar(
        title: Text(isProvider ? 'Buscar Trabajos' : 'Ofertas de Trabajo'),
        actions: [
          // Filtros
          IconButton(
            icon: Badge(
              isLabelVisible: state.filters != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: () {
              // TODO: Abrir diálogo de filtros
              _showFiltersDialog(context, ref);
            },
          ),
          // Ordenamiento
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            onSelected: (sortOption) {
              notifier.setSortOption(sortOption);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: JobSortOption.recent,
                child: Text('Más recientes'),
              ),
              PopupMenuItem(
                value: JobSortOption.urgent,
                child: Text('Más urgentes'),
              ),
              PopupMenuItem(
                value: JobSortOption.highestBudget,
                child: Text('Mayor presupuesto'),
              ),
              PopupMenuItem(
                value: JobSortOption.lowestBudget,
                child: Text('Menor presupuesto'),
              ),
              PopupMenuItem(
                value: JobSortOption.expiringSoon,
                child: Text('Próximos a expirar'),
              ),
            ],
          ),
          // Menú de usuario
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            tooltip: currentUser?.name ?? 'Usuario',
            onSelected: (value) {
              switch (value) {
                case 'proposals':
                  context.push('/proposals');
                  break;
                case 'professional-profile':
                  // Navegar al perfil profesional del usuario actual
                  context.push('/profile/professional/${currentUser?.id}?own=true');
                  break;
                case 'my-jobs':
                  context.push('/my-jobs');
                  break;
                case 'profile':
                  context.push('/profile/edit');
                  break;
                case 'settings':
                  context.push('/settings');
                  break;
                case 'logout':
                  _showLogoutDialog(context, ref);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'info',
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser?.name ?? 'Usuario',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentUser?.email ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              // Profesionales: Mis Propuestas
              if (isProvider)
                const PopupMenuItem(
                  value: 'proposals',
                  child: Row(
                    children: [
                      Icon(Icons.description, size: 20),
                      SizedBox(width: 12),
                      Text('Mis Propuestas'),
                    ],
                  ),
                ),
              // Profesionales: Mi Perfil Profesional
              if (isProvider)
                const PopupMenuItem(
                  value: 'professional-profile',
                  child: Row(
                    children: [
                      Icon(Icons.work_outline, size: 20),
                      SizedBox(width: 12),
                      Text('Mi Perfil Profesional'),
                    ],
                  ),
                ),
              // Clientes: Mis Ofertas
              if (isClient)
                const PopupMenuItem(
                  value: 'my-jobs',
                  child: Row(
                    children: [
                      Icon(Icons.work, size: 20),
                      SizedBox(width: 12),
                      Text('Mis Ofertas'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 12),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 12),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(state, notifier),
      // Solo los clientes pueden publicar trabajos
      floatingActionButton: isClient
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push('/jobs/create');
              },
              icon: const Icon(Icons.add),
              label: const Text('Publicar Trabajo'),
            )
          : null,
    );
  }

  Widget _buildBody(JobFeedState state, JobFeedNotifier notifier) {
    if (state.isLoading && state.jobs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar ofertas',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(state.error!),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => notifier.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.jobs.isEmpty) {
      return EmptyState(
        icon: Icons.work_outline,
        title: 'No hay ofertas disponibles',
        message: state.filters != null
            ? 'No se encontraron ofertas con los filtros aplicados. Intenta ajustar tus criterios de búsqueda.'
            : 'Aún no hay ofertas de trabajo publicadas. ¡Sé el primero en publicar!',
        actionLabel: state.filters != null ? 'Limpiar filtros' : null,
        onAction: state.filters != null ? () => notifier.clearFilters() : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.builder(
        itemCount: state.jobs.length,
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemBuilder: (context, index) {
          final job = state.jobs[index];
          return JobCard(
            job: job,
            onTap: () {
              context.push('/jobs/${job.id}');
            },
          );
        },
      ),
    );
  }

  void _showFiltersDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtros',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(jobFeedProvider.notifier).clearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Limpiar'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // TODO: Implementar controles de filtros
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Filtros próximamente'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.logout, color: Colors.orange, size: 48),
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/welcome');
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

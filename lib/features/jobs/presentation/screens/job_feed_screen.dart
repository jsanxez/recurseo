import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofertas de Trabajo'),
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
        ],
      ),
      body: _buildBody(state, notifier),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar a crear oferta
          context.push('/jobs/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Publicar Trabajo'),
      ),
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
}

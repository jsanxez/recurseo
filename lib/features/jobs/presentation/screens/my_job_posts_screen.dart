import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/my_job_posts_provider.dart';
import 'package:recurseo/features/jobs/presentation/widgets/empty_state.dart';
import 'package:recurseo/features/jobs/presentation/widgets/job_card.dart';

/// Pantalla de ofertas de trabajo publicadas por el cliente
class MyJobPostsScreen extends ConsumerWidget {
  const MyJobPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myJobPostsProvider);
    final notifier = ref.read(myJobPostsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ofertas'),
        actions: [
          // Filtro por estado
          PopupMenuButton<JobPostStatus?>(
            icon: Badge(
              isLabelVisible: state.filterStatus != null,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Filtrar por estado',
            onSelected: (status) {
              if (status == null) {
                notifier.clearFilters();
              } else {
                notifier.filterByStatus(status);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todas'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: JobPostStatus.open,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.green),
                    SizedBox(width: 12),
                    Text('Abiertas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: JobPostStatus.inReview,
                child: Row(
                  children: [
                    Icon(Icons.hourglass_empty, size: 20, color: Colors.orange),
                    SizedBox(width: 12),
                    Text('En revisión'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: JobPostStatus.filled,
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('Cubiertas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: JobPostStatus.closed,
                child: Row(
                  children: [
                    Icon(Icons.lock, size: 20, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Cerradas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: JobPostStatus.cancelled,
                child: Row(
                  children: [
                    Icon(Icons.cancel, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Canceladas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(context, state, notifier, theme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/jobs/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Oferta'),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MyJobPostsState state,
    MyJobPostsNotifier notifier,
    ThemeData theme,
  ) {
    if (state.isLoading && state.jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar ofertas',
              style: theme.textTheme.titleLarge,
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
        title: 'No tienes ofertas publicadas',
        message: state.filterStatus != null
            ? 'No hay ofertas con el estado seleccionado. Intenta cambiar el filtro.'
            : 'Aún no has publicado ninguna oferta de trabajo. ¡Publica tu primera oferta!',
        actionLabel: state.filterStatus != null ? 'Limpiar filtro' : 'Publicar Oferta',
        onAction: state.filterStatus != null
            ? () => notifier.clearFilters()
            : () => context.push('/jobs/create'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.builder(
        itemCount: state.jobs.length,
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemBuilder: (context, index) {
          final job = state.jobs[index];
          return _buildJobCardWithActions(context, job, notifier, theme);
        },
      ),
    );
  }

  Widget _buildJobCardWithActions(
    BuildContext context,
    JobPostEntity job,
    MyJobPostsNotifier notifier,
    ThemeData theme,
  ) {
    return Column(
      children: [
        JobCard(
          job: job,
          onTap: () {
            context.push('/jobs/${job.id}');
          },
        ),
        // Acciones rápidas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Ver propuestas
              TextButton.icon(
                onPressed: () {
                  context.push(
                    '/jobs/${job.id}/proposals?title=${Uri.encodeComponent(job.title)}',
                  );
                },
                icon: const Icon(Icons.description, size: 18),
                label: Text('${job.proposalsCount} Propuestas'),
              ),
              const SizedBox(width: 8),
              // Acciones según estado
              if (job.status == JobPostStatus.open) ...[
                TextButton.icon(
                  onPressed: () {
                    _showCloseJobDialog(context, job, notifier);
                  },
                  icon: const Icon(Icons.lock, size: 18),
                  label: const Text('Cerrar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                ),
              ] else if (job.status == JobPostStatus.inReview ||
                  job.status == JobPostStatus.open) ...[
                TextButton.icon(
                  onPressed: () {
                    _showCancelJobDialog(context, job, notifier);
                  },
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Cancelar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  void _showCloseJobDialog(
    BuildContext context,
    JobPostEntity job,
    MyJobPostsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.lock, color: Colors.orange, size: 48),
        title: const Text('Cerrar Oferta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas cerrar esta oferta?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'La oferta ya no aparecerá en el feed y no se aceptarán más propuestas.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.closeJob(job.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Cerrar Oferta'),
          ),
        ],
      ),
    );
  }

  void _showCancelJobDialog(
    BuildContext context,
    JobPostEntity job,
    MyJobPostsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.cancel, color: Colors.red, size: 48),
        title: const Text('Cancelar Oferta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas cancelar esta oferta?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_outlined, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Esta acción no se puede deshacer. La oferta será marcada como cancelada.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.cancelJob(job.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cancelar Oferta'),
          ),
        ],
      ),
    );
  }
}

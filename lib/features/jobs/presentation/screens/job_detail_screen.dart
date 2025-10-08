import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_detail_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Pantalla de detalle de una oferta de trabajo
class JobDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobDetailProvider(jobId));
    final currentUser = ref.watch(currentUserProvider);
    final isProvider = currentUser?.userType == UserType.provider;
    final theme = Theme.of(context);

    return Scaffold(
      body: _buildBody(context, state, theme),
      // Solo los profesionales pueden enviar propuestas
      floatingActionButton: isProvider &&
              state.job != null &&
              state.job!.status == JobPostStatus.open
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push(
                  '/jobs/${state.job!.id}/proposal?title=${Uri.encodeComponent(state.job!.title)}',
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Enviar Propuesta'),
            )
          : null,
    );
  }

  Widget _buildBody(
    BuildContext context,
    JobDetailState state,
    ThemeData theme,
  ) {
    if (state.isLoading && state.job == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.job == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al cargar la oferta', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(state.error!),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ],
        ),
      );
    }

    if (state.job == null) {
      return const Center(child: Text('Oferta no encontrada'));
    }

    final job = state.job!;

    return CustomScrollView(
      slivers: [
        // AppBar con imagen de fondo
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              job.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.work,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),

        // Contenido
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información principal
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Urgencia y estado
                    Row(
                      children: [
                        _buildUrgencyChip(job.urgency, theme),
                        const SizedBox(width: 8),
                        _buildStatusChip(job.status, theme),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ubicación
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job.location,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Descripción
                    Text(
                      'Descripción',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    // Detalles
                    Text(
                      'Detalles del trabajo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.work_outline,
                      label: 'Tipo',
                      value: _getJobTypeLabel(job.type),
                      theme: theme,
                    ),
                    _buildDetailRow(
                      icon: Icons.payments_outlined,
                      label: 'Pago',
                      value: '${_getPaymentTypeLabel(job.paymentType)}${_getBudgetText(job)}',
                      theme: theme,
                    ),
                    if (job.durationDays != null)
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Duración estimada',
                        value: '${job.durationDays} días',
                        theme: theme,
                      ),
                    _buildDetailRow(
                      icon: Icons.group_outlined,
                      label: 'Personas requeridas',
                      value: '${job.requiredWorkers}',
                      theme: theme,
                    ),
                    _buildDetailRow(
                      icon: Icons.description_outlined,
                      label: 'Propuestas recibidas',
                      value: '${job.proposalsCount}',
                      theme: theme,
                    ),
                    _buildDetailRow(
                      icon: Icons.schedule,
                      label: 'Publicado',
                      value: timeago.format(job.createdAt, locale: 'es'),
                      theme: theme,
                    ),
                    _buildDetailRow(
                      icon: Icons.event_busy,
                      label: 'Expira',
                      value: timeago.format(job.expiresAt, locale: 'es'),
                      theme: theme,
                    ),

                    // Requisitos
                    if (job.requirements.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Requisitos',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...job.requirements.map(
                        (req) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(req)),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 100), // Espacio para el botón
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyChip(UrgencyLevel urgency, ThemeData theme) {
    Color color;
    String label;

    switch (urgency) {
      case UrgencyLevel.urgente:
        color = Colors.red;
        label = 'URGENTE';
        break;
      case UrgencyLevel.normal:
        color = Colors.orange;
        label = 'Normal';
        break;
      case UrgencyLevel.flexible:
        color = Colors.green;
        label = 'Flexible';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(JobPostStatus status, ThemeData theme) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case JobPostStatus.open:
        color = Colors.green;
        label = 'Abierta';
        icon = Icons.check_circle;
        break;
      case JobPostStatus.inReview:
        color = Colors.orange;
        label = 'En revisión';
        icon = Icons.hourglass_empty;
        break;
      case JobPostStatus.closed:
        color = Colors.grey;
        label = 'Cerrada';
        icon = Icons.lock;
        break;
      case JobPostStatus.filled:
        color = Colors.blue;
        label = 'Cubierta';
        icon = Icons.done_all;
        break;
      case JobPostStatus.cancelled:
        color = Colors.red;
        label = 'Cancelada';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getJobTypeLabel(JobType type) {
    switch (type) {
      case JobType.temporal:
        return 'Temporal';
      case JobType.permanente:
        return 'Permanente';
      case JobType.porProyecto:
        return 'Por proyecto';
    }
  }

  String _getPaymentTypeLabel(PaymentType type) {
    switch (type) {
      case PaymentType.porDia:
        return 'Por día';
      case PaymentType.porHora:
        return 'Por hora';
      case PaymentType.porProyecto:
        return 'Por proyecto';
    }
  }

  String _getBudgetText(JobPostEntity job) {
    if (job.budgetMin != null && job.budgetMax != null) {
      return ' - \$${job.budgetMin!.toStringAsFixed(0)} a \$${job.budgetMax!.toStringAsFixed(0)}';
    } else if (job.budgetMin != null) {
      return ' - Desde \$${job.budgetMin!.toStringAsFixed(0)}';
    } else if (job.budgetMax != null) {
      return ' - Hasta \$${job.budgetMax!.toStringAsFixed(0)}';
    }
    return '';
  }
}

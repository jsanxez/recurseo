import 'package:flutter/material.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Tarjeta para mostrar una oferta de trabajo en el feed
class JobCard extends StatelessWidget {
  final JobPostEntity job;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Título y urgencia
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildUrgencyChip(),
                ],
              ),
              const SizedBox(height: 8),

              // Ubicación
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Descripción
              Text(
                job.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Detalles: tipo, pago, trabajadores
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.work_outline,
                    label: _getJobTypeLabel(job.type),
                    context: context,
                  ),
                  _buildInfoChip(
                    icon: Icons.payments_outlined,
                    label: _getBudgetLabel(),
                    context: context,
                  ),
                  if (job.requiredWorkers > 1)
                    _buildInfoChip(
                      icon: Icons.group_outlined,
                      label: '${job.requiredWorkers} personas',
                      context: context,
                    ),
                  if (job.durationDays != null)
                    _buildInfoChip(
                      icon: Icons.calendar_today_outlined,
                      label: '${job.durationDays} días',
                      context: context,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Footer: Tiempo y propuestas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Publicado ${timeago.format(job.createdAt, locale: 'es')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${job.proposalsCount} propuestas',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyChip() {
    Color color;
    String label;

    switch (job.urgency) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
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

  String _getBudgetLabel() {
    if (job.budgetMin != null && job.budgetMax != null) {
      return '\$${job.budgetMin!.toStringAsFixed(0)} - \$${job.budgetMax!.toStringAsFixed(0)}';
    } else if (job.budgetMin != null) {
      return 'Desde \$${job.budgetMin!.toStringAsFixed(0)}';
    } else if (job.budgetMax != null) {
      return 'Hasta \$${job.budgetMax!.toStringAsFixed(0)}';
    }

    final paymentTypeLabel = _getPaymentTypeLabel(job.paymentType);
    return paymentTypeLabel;
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
}

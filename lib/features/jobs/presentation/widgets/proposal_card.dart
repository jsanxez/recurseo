import 'package:flutter/material.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Tarjeta para mostrar una propuesta
class ProposalCard extends StatelessWidget {
  final ProposalEntity proposal;
  final VoidCallback? onTap;
  final bool showJobInfo;

  const ProposalCard({
    super.key,
    required this.proposal,
    this.onTap,
    this.showJobInfo = false,
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
              // Header: Nombre profesional y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      proposal.professionalName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 12),

              // Mensaje de la propuesta
              Text(
                proposal.message,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Detalles: tarifa, disponibilidad, experiencia
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.payments_outlined,
                    label: '\$${proposal.proposedRate.toStringAsFixed(0)} ${proposal.rateType}',
                    context: context,
                  ),
                  _buildInfoChip(
                    icon: Icons.calendar_today_outlined,
                    label: 'Disponible ${timeago.format(proposal.availableFrom, locale: 'es')}',
                    context: context,
                  ),
                  if (proposal.yearsExperience != null)
                    _buildInfoChip(
                      icon: Icons.work_outline,
                      label: '${proposal.yearsExperience} años exp.',
                      context: context,
                    ),
                  if (proposal.estimatedDuration != null)
                    _buildInfoChip(
                      icon: Icons.timer_outlined,
                      label: proposal.estimatedDuration!,
                      context: context,
                    ),
                ],
              ),

              // Portfolio
              if (proposal.portfolioUrls.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${proposal.portfolioUrls.length} fotos de portfolio',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],

              // Footer: Fecha de envío
              const SizedBox(height: 12),
              Text(
                'Enviado ${timeago.format(proposal.createdAt, locale: 'es')}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              // Razón de rechazo si aplica
              if (proposal.status == ProposalStatus.rejected &&
                  proposal.rejectionReason != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          proposal.rejectionReason!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (proposal.status) {
      case ProposalStatus.pending:
        color = Colors.orange;
        label = 'Pendiente';
        icon = Icons.schedule;
        break;
      case ProposalStatus.accepted:
        color = Colors.green;
        label = 'Aceptada';
        icon = Icons.check_circle;
        break;
      case ProposalStatus.rejected:
        color = Colors.red;
        label = 'Rechazada';
        icon = Icons.cancel;
        break;
      case ProposalStatus.withdrawn:
        color = Colors.grey;
        label = 'Retirada';
        icon = Icons.remove_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
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
}

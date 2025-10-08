import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/proposal_detail_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Pantalla de detalle de una propuesta
class ProposalDetailScreen extends ConsumerWidget {
  final String proposalId;

  const ProposalDetailScreen({
    super.key,
    required this.proposalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(proposalDetailProvider(proposalId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Propuesta'),
      ),
      body: _buildBody(context, ref, state, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProposalDetailState state,
    ThemeData theme,
  ) {
    if (state.isLoading && state.proposal == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.proposal == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al cargar la propuesta', style: theme.textTheme.titleLarge),
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

    if (state.proposal == null) {
      return const Center(child: Text('Propuesta no encontrada'));
    }

    final proposal = state.proposal!;

    return RefreshIndicator(
      onRefresh: () => ref.read(proposalDetailProvider(proposalId).notifier).refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de la propuesta
            Center(child: _buildStatusBanner(proposal, theme)),
            const SizedBox(height: 24),

            // Información del trabajo
            if (proposal.jobTitle != null) ...[
              _buildSectionTitle('Trabajo', theme),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(Icons.work, color: theme.colorScheme.primary),
                  title: Text(
                    proposal.jobTitle!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/jobs/${proposal.jobPostId}');
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Información del profesional
            _buildSectionTitle('Profesional', theme),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: proposal.professionalPhotoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                proposal.professionalPhotoUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.person, size: 30, color: theme.colorScheme.primary),
                              ),
                            )
                          : Icon(Icons.person, size: 30, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proposal.professionalName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (proposal.yearsExperience != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${proposal.yearsExperience} años de experiencia',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mensaje de la propuesta
            _buildSectionTitle('Propuesta', theme),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  proposal.message,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Detalles de la propuesta
            _buildSectionTitle('Detalles', theme),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.payments_outlined,
                      label: 'Tarifa propuesta',
                      value: proposal.formattedRate,
                      theme: theme,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Disponible desde',
                      value: _formatDate(proposal.availableFrom),
                      theme: theme,
                    ),
                    if (proposal.estimatedDuration != null) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.timer_outlined,
                        label: 'Duración estimada',
                        value: proposal.estimatedDuration!,
                        theme: theme,
                      ),
                    ],
                    if (proposal.estimatedDays != null) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.event_outlined,
                        label: 'Días estimados',
                        value: '${proposal.estimatedDays} días',
                        theme: theme,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Portfolio
            if (proposal.portfolioUrls.isNotEmpty) ...[
              _buildSectionTitle('Portfolio', theme),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${proposal.portfolioUrls.length} fotos de trabajos anteriores',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: proposal.portfolioUrls.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, size: 40),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Razón de rechazo
            if (proposal.status == ProposalStatus.rejected &&
                proposal.rejectionReason != null) ...[
              _buildSectionTitle('Razón de rechazo', theme),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        proposal.rejectionReason!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Fechas importantes
            _buildSectionTitle('Información adicional', theme),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.send_outlined,
                      label: 'Enviada',
                      value: timeago.format(proposal.createdAt, locale: 'es'),
                      theme: theme,
                    ),
                    if (proposal.acceptedAt != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.check_circle_outline,
                        label: 'Aceptada',
                        value: timeago.format(proposal.acceptedAt!, locale: 'es'),
                        theme: theme,
                      ),
                    ],
                    if (proposal.rejectedAt != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.cancel_outlined,
                        label: 'Rechazada',
                        value: timeago.format(proposal.rejectedAt!, locale: 'es'),
                        theme: theme,
                      ),
                    ],
                    if (proposal.withdrawnAt != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.remove_circle_outline,
                        label: 'Retirada',
                        value: timeago.format(proposal.withdrawnAt!, locale: 'es'),
                        theme: theme,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(ProposalEntity proposal, ThemeData theme) {
    Color color;
    String label;
    IconData icon;

    switch (proposal.status) {
      case ProposalStatus.pending:
        color = Colors.orange;
        label = 'Propuesta Pendiente';
        icon = Icons.schedule;
        break;
      case ProposalStatus.accepted:
        color = Colors.green;
        label = 'Propuesta Aceptada';
        icon = Icons.check_circle;
        break;
      case ProposalStatus.rejected:
        color = Colors.red;
        label = 'Propuesta Rechazada';
        icon = Icons.cancel;
        break;
      case ProposalStatus.withdrawn:
        color = Colors.grey;
        label = 'Propuesta Retirada';
        icon = Icons.remove_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

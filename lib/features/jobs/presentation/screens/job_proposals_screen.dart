import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_proposals_provider.dart';
import 'package:recurseo/features/jobs/presentation/widgets/contact_card.dart';
import 'package:recurseo/features/jobs/presentation/widgets/empty_state.dart';
import 'package:recurseo/features/jobs/presentation/widgets/proposal_card.dart';

/// Pantalla de propuestas recibidas para una oferta de trabajo
class JobProposalsScreen extends ConsumerWidget {
  final String jobId;
  final String? jobTitle;

  const JobProposalsScreen({
    super.key,
    required this.jobId,
    this.jobTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobProposalsProvider(jobId));
    final notifier = ref.read(jobProposalsProvider(jobId).notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Propuestas Recibidas'),
            if (jobTitle != null)
              Text(
                jobTitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          // Filtro por estado
          PopupMenuButton<ProposalStatus?>(
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
                value: ProposalStatus.pending,
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 20, color: Colors.orange),
                    SizedBox(width: 12),
                    Text('Pendientes'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ProposalStatus.accepted,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.green),
                    SizedBox(width: 12),
                    Text('Aceptadas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ProposalStatus.rejected,
                child: Row(
                  children: [
                    Icon(Icons.cancel, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Rechazadas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ProposalStatus.withdrawn,
                child: Row(
                  children: [
                    Icon(Icons.remove_circle, size: 20, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Retiradas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Estadísticas
          if (state.proposals.isNotEmpty)
            _buildStats(context, state, theme),

          // Lista de propuestas
          Expanded(
            child: _buildBody(context, state, notifier, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(
    BuildContext context,
    JobProposalsState state,
    ThemeData theme,
  ) {
    final stats = state.stats;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.description,
            label: 'Total',
            value: '${stats['total']}',
            color: theme.colorScheme.primary,
          ),
          _buildStatItem(
            icon: Icons.schedule,
            label: 'Pendientes',
            value: '${stats['pending']}',
            color: Colors.orange,
          ),
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'Aceptadas',
            value: '${stats['accepted']}',
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.cancel,
            label: 'Rechazadas',
            value: '${stats['rejected']}',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    JobProposalsState state,
    JobProposalsNotifier notifier,
    ThemeData theme,
  ) {
    if (state.isLoading && state.proposals.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.proposals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar propuestas',
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

    if (state.proposals.isEmpty) {
      return EmptyState(
        icon: Icons.description_outlined,
        title: 'No hay propuestas',
        message: state.filterStatus != null
            ? 'No hay propuestas con el estado seleccionado. Intenta cambiar el filtro.'
            : 'Aún no has recibido propuestas para esta oferta. Los profesionales interesados podrán enviar sus propuestas pronto.',
        actionLabel: state.filterStatus != null ? 'Limpiar filtro' : null,
        onAction: state.filterStatus != null ? () => notifier.clearFilters() : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.builder(
        itemCount: state.proposals.length,
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemBuilder: (context, index) {
          final proposal = state.proposals[index];
          return _buildProposalWithActions(
            context,
            proposal,
            notifier,
            theme,
          );
        },
      ),
    );
  }

  Widget _buildProposalWithActions(
    BuildContext context,
    ProposalEntity proposal,
    JobProposalsNotifier notifier,
    ThemeData theme,
  ) {
    return Column(
      children: [
        ProposalCard(
          proposal: proposal,
          onTap: () {
            context.push('/proposals/${proposal.id}');
          },
        ),
        // Acciones para propuestas pendientes
        if (proposal.status == ProposalStatus.pending)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showRejectDialog(context, proposal, notifier);
                  },
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Rechazar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    _showAcceptDialog(context, proposal, notifier);
                  },
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Aceptar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showAcceptDialog(
    BuildContext context,
    ProposalEntity proposal,
    JobProposalsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Aceptar Propuesta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de que deseas aceptar la propuesta de ${proposal.professionalName}?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Al aceptar, el profesional será notificado y podrás coordinar los detalles del trabajo.',
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
              final success = await notifier.acceptProposal(proposal.id);
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Propuesta aceptada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Mostrar información de contacto
                _showContactDialog(context, proposal);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Aceptar Propuesta'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    ProposalEntity proposal,
    JobProposalsNotifier notifier,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.cancel, color: Colors.red, size: 48),
        title: const Text('Rechazar Propuesta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de que deseas rechazar la propuesta de ${proposal.professionalName}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Razón (opcional)',
                hintText: 'Escribe el motivo del rechazo...',
                border: OutlineInputBorder(),
                helperText: 'Esto ayudará al profesional a mejorar sus propuestas',
              ),
              maxLines: 3,
              maxLength: 500,
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
              final reason = reasonController.text.trim();
              final success = await notifier.rejectProposal(
                proposal.id,
                reason: reason.isNotEmpty ? reason : null,
              );
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Propuesta rechazada'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(
    BuildContext context,
    ProposalEntity proposal,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('¡Propuesta Aceptada!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ahora puedes contactar al profesional para coordinar los detalles del trabajo:',
            ),
            const SizedBox(height: 16),
            ContactCard(
              professionalName: proposal.professionalName,
              phone: proposal.professionalPhone,
              email: proposal.professionalEmail,
              preFilledMessage:
                  'Hola ${proposal.professionalName}, acepté tu propuesta para "${proposal.jobTitle ?? 'el trabajo'}". Me gustaría coordinar los detalles.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.push('/proposals/${proposal.id}');
            },
            icon: const Icon(Icons.visibility),
            label: const Text('Ver Propuesta'),
          ),
        ],
      ),
    );
  }
}

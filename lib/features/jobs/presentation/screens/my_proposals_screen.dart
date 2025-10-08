import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/my_proposals_provider.dart';
import 'package:recurseo/features/jobs/presentation/widgets/empty_state.dart';
import 'package:recurseo/features/jobs/presentation/widgets/proposal_card.dart';

/// Pantalla con las propuestas enviadas por el profesional
class MyProposalsScreen extends ConsumerWidget {
  const MyProposalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProposalsProvider);
    final notifier = ref.read(myProposalsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Propuestas'),
        actions: [
          // Filtro por estado
          PopupMenuButton<ProposalStatus?>(
            icon: Badge(
              isLabelVisible: state.filterStatus != null,
              child: const Icon(Icons.filter_list),
            ),
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
                child: Row(
                  children: [
                    Icon(Icons.clear, size: 20),
                    SizedBox(width: 8),
                    Text('Todas'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: ProposalStatus.pending,
                child: Row(
                  children: [
                    Icon(Icons.hourglass_empty, size: 20, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Text('Pendientes'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ProposalStatus.accepted,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('Aceptadas'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ProposalStatus.rejected,
                child: Row(
                  children: [
                    Icon(Icons.cancel, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Rechazadas'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ProposalStatus.withdrawn,
                child: Row(
                  children: [
                    Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text('Retiradas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(context, state, notifier, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MyProposalsState state,
    MyProposalsNotifier notifier,
    ThemeData theme,
  ) {
    if (state.isLoading && state.proposals.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.proposals.isEmpty) {
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
            ? 'No tienes propuestas con el estado seleccionado.'
            : 'Aún no has enviado propuestas. Explora las ofertas de trabajo y envía tu primera propuesta.',
        actionLabel: state.filterStatus != null ? 'Limpiar filtros' : 'Ver ofertas',
        onAction: () {
          if (state.filterStatus != null) {
            notifier.clearFilters();
          } else {
            context.go('/home');
          }
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: Column(
        children: [
          // Indicador de filtro activo
          if (state.filterStatus != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filtrando por: ${_getStatusLabel(state.filterStatus!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => notifier.clearFilters(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Limpiar',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // Lista de propuestas
          Expanded(
            child: ListView.builder(
              itemCount: state.proposals.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final proposal = state.proposals[index];
                return ProposalCard(
                  proposal: proposal,
                  showJobTitle: true,
                  onTap: () {
                    // TODO: Navegar a detalle de propuesta
                    context.push('/proposals/${proposal.id}');
                  },
                  onWithdraw: proposal.status == ProposalStatus.pending
                      ? () => _showWithdrawDialog(context, notifier, proposal.id)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.pending:
        return 'Pendientes';
      case ProposalStatus.accepted:
        return 'Aceptadas';
      case ProposalStatus.rejected:
        return 'Rechazadas';
      case ProposalStatus.withdrawn:
        return 'Retiradas';
    }
  }

  void _showWithdrawDialog(
    BuildContext context,
    MyProposalsNotifier notifier,
    String proposalId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber,
          color: Colors.orange,
          size: 48,
        ),
        title: const Text('Retirar Propuesta'),
        content: const Text(
          '¿Estás seguro de que deseas retirar esta propuesta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              notifier.withdrawProposal(proposalId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Retirar'),
          ),
        ],
      ),
    );
  }
}

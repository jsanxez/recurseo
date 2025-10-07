import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/requests/domain/entities/request_entity.dart';
import 'package:recurseo/features/requests/presentation/providers/request_providers.dart';

/// Pantalla de solicitudes recibidas por el proveedor
class ProviderRequestsScreen extends ConsumerStatefulWidget {
  const ProviderRequestsScreen({super.key});

  @override
  ConsumerState<ProviderRequestsScreen> createState() =>
      _ProviderRequestsScreenState();
}

class _ProviderRequestsScreenState
    extends ConsumerState<ProviderRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes Recibidas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes', icon: Icon(Icons.schedule)),
            Tab(text: 'Activas', icon: Icon(Icons.timelapse)),
            Tab(text: 'Todas', icon: Icon(Icons.list)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PendingRequestsTab(),
          _ActiveRequestsTab(),
          _AllRequestsTab(),
        ],
      ),
    );
  }
}

class _PendingRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingProviderRequestsProvider);

    return requestsAsync.when(
      data: (requests) => _RequestsList(
        requests: requests,
        emptyMessage: 'No tienes solicitudes pendientes',
        emptyIcon: Icons.inbox_outlined,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorWidget(
        onRetry: () => ref.invalidate(pendingProviderRequestsProvider),
      ),
    );
  }
}

class _ActiveRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(activeProviderRequestsProvider);

    return requestsAsync.when(
      data: (requests) => _RequestsList(
        requests: requests,
        emptyMessage: 'No tienes solicitudes activas',
        emptyIcon: Icons.work_outline,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorWidget(
        onRetry: () => ref.invalidate(activeProviderRequestsProvider),
      ),
    );
  }
}

class _AllRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(providerRequestsProvider);

    return requestsAsync.when(
      data: (requests) => _RequestsList(
        requests: requests,
        emptyMessage: 'No has recibido solicitudes aún',
        emptyIcon: Icons.inbox_outlined,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorWidget(
        onRetry: () => ref.invalidate(providerRequestsProvider),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  final List<RequestEntity> requests;
  final String emptyMessage;
  final IconData emptyIcon;

  const _RequestsList({
    required this.requests,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyIcon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // La invalidación se hace en el Consumer padre
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (context, index) {
          final request = requests[index];
          return _ProviderRequestCard(request: request);
        },
      ),
    );
  }
}

class _ProviderRequestCard extends StatelessWidget {
  final RequestEntity request;

  const _ProviderRequestCard({required this.request});

  Color _getStatusColor() {
    return switch (request.status) {
      RequestStatus.pending => AppColors.warning,
      RequestStatus.accepted => AppColors.success,
      RequestStatus.rejected => AppColors.error,
      RequestStatus.inProgress => AppColors.info,
      RequestStatus.completed => AppColors.success,
      RequestStatus.cancelled => Colors.grey,
    };
  }

  IconData _getStatusIcon() {
    return switch (request.status) {
      RequestStatus.pending => Icons.schedule,
      RequestStatus.accepted => Icons.check_circle_outline,
      RequestStatus.rejected => Icons.cancel_outlined,
      RequestStatus.inProgress => Icons.timelapse,
      RequestStatus.completed => Icons.check_circle,
      RequestStatus.cancelled => Icons.block,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: request.status == RequestStatus.pending ? 4 : 2,
      child: InkWell(
        onTap: () {
          context.push('/requests/${request.id}');
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          decoration: request.status == RequestStatus.pending
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.5),
                    width: 2,
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con título y estado
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        border: Border.all(
                          color: _getStatusColor().withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(),
                            size: 16,
                            color: _getStatusColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.statusText,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getStatusColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Badge de nueva solicitud
                if (request.status == RequestStatus.pending) ...[
                  const SizedBox(height: AppSizes.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fiber_new, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Requiere respuesta',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.sm),

                // Descripción
                Text(
                  request.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.sm),

                // Información adicional
                Wrap(
                  spacing: AppSizes.md,
                  runSpacing: AppSizes.xs,
                  children: [
                    if (request.location != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.location!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                    if (request.budgetFrom != null && request.budgetTo != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          Text(
                            '\$${request.budgetFrom!.toStringAsFixed(0)} - \$${request.budgetTo!.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    if (request.preferredDate != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${request.preferredDate!.day}/${request.preferredDate!.month}/${request.preferredDate!.year}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Recibida: ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppSizes.md),
          Text(
            'Error al cargar solicitudes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.md),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

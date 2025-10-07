import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/requests/domain/entities/request_entity.dart';
import 'package:recurseo/features/requests/presentation/providers/request_providers.dart';

/// Pantalla de detalle de una solicitud
class RequestDetailScreen extends ConsumerWidget {
  final String requestId;

  const RequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(requestByIdProvider(requestId));
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Solicitud'),
      ),
      body: requestAsync.when(
        data: (request) {
          final isClient = authState is Authenticated &&
              authState.user.id == request.clientId;
          final isProvider = authState is Authenticated &&
              authState.user.id == request.providerId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estado
                _StatusCard(request: request),
                const SizedBox(height: AppSizes.lg),

                // Información básica
                _InfoSection(
                  title: 'Información',
                  children: [
                    _InfoRow(
                      icon: Icons.title,
                      label: 'Título',
                      value: request.title,
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.description,
                      label: 'Descripción',
                      value: request.description,
                    ),
                    if (request.location != null) ...[
                      const Divider(),
                      _InfoRow(
                        icon: Icons.location_on,
                        label: 'Ubicación',
                        value: request.location!,
                      ),
                    ],
                    if (request.preferredDate != null) ...[
                      const Divider(),
                      _InfoRow(
                        icon: Icons.calendar_today,
                        label: 'Fecha Preferida',
                        value:
                            '${request.preferredDate!.day}/${request.preferredDate!.month}/${request.preferredDate!.year}',
                      ),
                    ],
                    if (request.budgetFrom != null &&
                        request.budgetTo != null) ...[
                      const Divider(),
                      _InfoRow(
                        icon: Icons.attach_money,
                        label: 'Presupuesto',
                        value:
                            '\$${request.budgetFrom!.toStringAsFixed(0)} - \$${request.budgetTo!.toStringAsFixed(0)}',
                      ),
                    ],
                    const Divider(),
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'Creada',
                      value:
                          '${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.lg),

                // Respuesta del proveedor
                if (request.providerResponse != null) ...[
                  _InfoSection(
                    title: 'Respuesta del Proveedor',
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.sm),
                        child: Text(
                          request.providerResponse!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],

                // Acciones para cliente
                if (isClient) ...[
                  if (request.canBeCancelled)
                    _CancelButton(requestId: request.id),
                ],

                // Acciones para proveedor
                if (isProvider) ...[
                  if (request.canBeResponded) ...[
                    _ProviderActionButtons(request: request),
                  ] else if (request.status == RequestStatus.accepted) ...[
                    FilledButton.icon(
                      onPressed: () => _markAsInProgress(context, ref, request.id),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Marcar En Progreso'),
                    ),
                  ] else if (request.status == RequestStatus.inProgress) ...[
                    FilledButton.icon(
                      onPressed: () => _markAsCompleted(context, ref, request.id),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Marcar Como Completada'),
                    ),
                  ],
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSizes.md),
              Text('Error al cargar solicitud',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.sm),
              Text(error.toString(),
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markAsInProgress(
      BuildContext context, WidgetRef ref, String requestId) async {
    final repository = ref.read(requestRepositoryProvider);
    final result = await repository.markAsInProgress(requestId);

    if (!context.mounted) return;

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud marcada como en progreso'),
            backgroundColor: AppColors.success,
          ),
        );
        ref.invalidate(requestByIdProvider(requestId));
        ref.invalidate(providerRequestsProvider);
      case Failure(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
    }
  }

  Future<void> _markAsCompleted(
      BuildContext context, WidgetRef ref, String requestId) async {
    final repository = ref.read(requestRepositoryProvider);
    final result = await repository.markAsCompleted(requestId);

    if (!context.mounted) return;

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud completada exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        ref.invalidate(requestByIdProvider(requestId));
        ref.invalidate(providerRequestsProvider);
      case Failure(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
    }
  }
}

class _StatusCard extends StatelessWidget {
  final RequestEntity request;

  const _StatusCard({required this.request});

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
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: _getStatusColor().withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(), color: _getStatusColor(), size: 32),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(),
                      ),
                ),
                Text(
                  request.statusText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelButton extends ConsumerWidget {
  final String requestId;

  const _CancelButton({required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: () => _showCancelDialog(context, ref),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.error,
      ),
      icon: const Icon(Icons.cancel),
      label: const Text('Cancelar Solicitud'),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Solicitud'),
        content: const Text(
            '¿Estás seguro de que deseas cancelar esta solicitud?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repository = ref.read(requestRepositoryProvider);
      final result = await repository.cancelRequest(requestId);

      if (!context.mounted) return;

      switch (result) {
        case Success():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solicitud cancelada'),
              backgroundColor: AppColors.success,
            ),
          );
          ref.invalidate(requestByIdProvider(requestId));
          ref.invalidate(clientRequestsProvider);
        case Failure(message: final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.error),
          );
      }
    }
  }
}

class _ProviderActionButtons extends ConsumerStatefulWidget {
  final RequestEntity request;

  const _ProviderActionButtons({required this.request});

  @override
  ConsumerState<_ProviderActionButtons> createState() =>
      _ProviderActionButtonsState();
}

class _ProviderActionButtonsState
    extends ConsumerState<_ProviderActionButtons> {
  final _responseController = TextEditingController();

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => _showAcceptDialog(context),
          icon: const Icon(Icons.check_circle),
          label: const Text('Aceptar Solicitud'),
        ),
        const SizedBox(height: AppSizes.sm),
        OutlinedButton.icon(
          onPressed: () => _showRejectDialog(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
          ),
          icon: const Icon(Icons.cancel),
          label: const Text('Rechazar Solicitud'),
        ),
      ],
    );
  }

  Future<void> _showAcceptDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aceptar Solicitud'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mensaje opcional para el cliente:'),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _responseController,
              decoration: const InputDecoration(
                hintText: 'Ej: Estaré disponible el lunes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repository = ref.read(requestRepositoryProvider);
      final result = await repository.acceptRequest(
        requestId: widget.request.id,
        response: _responseController.text.trim().isEmpty
            ? null
            : _responseController.text.trim(),
      );

      if (!context.mounted) return;

      switch (result) {
        case Success():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solicitud aceptada'),
              backgroundColor: AppColors.success,
            ),
          );
          ref.invalidate(requestByIdProvider(widget.request.id));
          ref.invalidate(providerRequestsProvider);
        case Failure(message: final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.error),
          );
      }
    }
  }

  Future<void> _showRejectDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar Solicitud'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Motivo del rechazo:'),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _responseController,
              decoration: const InputDecoration(
                hintText: 'Explica por qué no puedes realizar este servicio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (_responseController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes indicar un motivo')),
                );
                return;
              }
              context.pop(true);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repository = ref.read(requestRepositoryProvider);
      final result = await repository.rejectRequest(
        requestId: widget.request.id,
        reason: _responseController.text.trim(),
      );

      if (!context.mounted) return;

      switch (result) {
        case Success():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solicitud rechazada'),
              backgroundColor: AppColors.success,
            ),
          );
          ref.invalidate(requestByIdProvider(widget.request.id));
          ref.invalidate(providerRequestsProvider);
        case Failure(message: final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.error),
          );
      }
    }
  }
}

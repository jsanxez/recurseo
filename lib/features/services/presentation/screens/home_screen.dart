import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/chat/presentation/providers/chat_providers.dart';
import 'package:recurseo/features/requests/presentation/providers/request_providers.dart';
import 'package:recurseo/features/services/presentation/providers/catalog_providers.dart';

/// Pantalla principal de la aplicación
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const _RequestsTab(),
    const _MessagesTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Solicitudes',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Mensajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Tab de Inicio
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Recurseo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Buscador
              _SearchBar(),
              const SizedBox(height: AppSizes.paddingLg),

              // Categorías populares
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categorías Populares',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/categories');
                    },
                    child: const Text('Ver todas'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingMd),
              const _CategoriesGrid(),
              const SizedBox(height: AppSizes.paddingLg),

              // Servicios destacados
              Text(
                'Servicios Destacados',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.paddingMd),
              _ServicesList(),
            ]),
          ),
        ),
      ],
    );
  }
}

// Buscador
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: '¿Qué servicio necesitas?',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () {},
        ),
      ),
    );
  }
}

// Grid de categorías
class _CategoriesGrid extends ConsumerWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        final displayCategories = categories.take(6).toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSizes.paddingMd,
            mainAxisSpacing: AppSizes.paddingMd,
            childAspectRatio: 1,
          ),
          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final category = displayCategories[index];
            return Card(
              child: InkWell(
                onTap: () {
                  context.push('/services/category/${category.id}');
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      size: 32,
                      color: category.color,
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingXl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// Lista de servicios
class _ServicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Servicio de ejemplo ${index + 1}'),
            subtitle: Text('Categoría • ⭐ 4.${5 + index}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }
}

// Tab de Solicitudes
class _RequestsTab extends ConsumerWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isProvider =
        authState is Authenticated && authState.user.userType == UserType.provider;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(isProvider ? 'Solicitudes Recibidas' : 'Mis Solicitudes'),
          floating: true,
          actions: [
            if (!isProvider)
              TextButton(
                onPressed: () => context.push('/requests'),
                child: const Text('Ver todas'),
              ),
          ],
        ),
        if (isProvider)
          _ProviderRequestsContent()
        else
          _ClientRequestsContent(),
      ],
    );
  }
}

class _ClientRequestsContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(clientRequestsProvider);

    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'No tienes solicitudes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        final displayRequests = requests.take(5).toList();
        return SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final request = displayRequests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                  child: InkWell(
                    onTap: () => context.push('/requests/${request.id}'),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Chip(
                                label: Text(request.statusText),
                                backgroundColor:
                                    _getStatusColor(request).withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingSm),
                          Text(
                            request.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSizes.paddingSm),
                          Text(
                            '${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: displayRequests.length,
            ),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSizes.md),
              const Text('Error al cargar solicitudes'),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(request) {
    return switch (request.status) {
      RequestStatus.pending => AppColors.warning,
      RequestStatus.accepted => AppColors.success,
      RequestStatus.rejected => AppColors.error,
      RequestStatus.inProgress => AppColors.info,
      RequestStatus.completed => AppColors.success,
      RequestStatus.cancelled => Colors.grey,
    };
  }
}

class _ProviderRequestsContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingProviderRequestsProvider);

    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'No tienes solicitudes pendientes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  TextButton(
                    onPressed: () => context.push('/provider/requests'),
                    child: const Text('Ver todas las solicitudes'),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final request = requests[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                  child: InkWell(
                    onTap: () => context.push('/requests/${request.id}'),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.sm,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.radiusSm),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.fiber_new,
                                          size: 16, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        'NUEVA',
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
                            ),
                            const SizedBox(height: AppSizes.sm),
                            Text(
                              request.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              request.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (request.budgetFrom != null &&
                                request.budgetTo != null) ...[
                              const SizedBox(height: AppSizes.sm),
                              Row(
                                children: [
                                  const Icon(Icons.attach_money,
                                      size: 16, color: AppColors.success),
                                  Text(
                                    '\$${request.budgetFrom!.toStringAsFixed(0)} - \$${request.budgetTo!.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: requests.length,
            ),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSizes.md),
              const Text('Error al cargar solicitudes'),
            ],
          ),
        ),
      ),
    );
  }
}

// Tab de Mensajes
class _MessagesTab extends ConsumerWidget {
  const _MessagesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId =
        authState is Authenticated ? authState.user.id : '';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Mensajes'),
          floating: true,
          actions: [
            TextButton(
              onPressed: () => context.push('/conversations'),
              child: const Text('Ver todas'),
            ),
          ],
        ),
        conversationsAsync.when(
          data: (conversations) {
            if (conversations.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: AppSizes.paddingMd),
                      Text(
                        'No tienes mensajes aún',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final displayConversations = conversations.take(5).toList();
            return SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final conversation = displayConversations[index];
                    final otherUserName =
                        conversation.getOtherUserName(currentUserId);
                    final hasUnread = conversation.hasUnreadMessages;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          otherUserName[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        otherUserName,
                        style: TextStyle(
                          fontWeight:
                              hasUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        conversation.lastMessagePreview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: hasUnread ? Colors.black87 : Colors.grey[600],
                          fontWeight:
                              hasUnread ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            conversation.lastMessageTime,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: hasUnread
                                      ? AppColors.primary
                                      : Colors.grey[500],
                                ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                conversation.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        context.push('/chat/${conversation.id}');
                      },
                    );
                  },
                  childCount: displayConversations.length,
                ),
              ),
            );
          },
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: AppSizes.md),
                  const Text('Error al cargar mensajes'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Tab de Perfil
class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Perfil'),
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header del perfil
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    Text(
                      user?.name ?? 'Usuario',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      user?.email ?? 'usuario@email.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingXl),

              // Opciones
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Editar perfil'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.push('/profile/edit');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.work_outline),
                      title: const Text('Ser proveedor'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Configuración'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.push('/settings');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Ayuda'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Acerca de'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              // Botón de cerrar sesión
              OutlinedButton.icon(
                onPressed: () async {
                  // Mostrar confirmación
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: const Text('Cerrar Sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    ref.read(authNotifierProvider.notifier).logout();
                    context.go('/welcome');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

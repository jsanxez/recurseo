import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/chat/domain/entities/conversation_entity.dart';
import 'package:recurseo/features/chat/presentation/providers/chat_providers.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';

/// Pantalla de lista de conversaciones
class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId =
        authState is Authenticated ? authState.user.id : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'No tienes conversaciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Inicia una conversación desde un servicio',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(conversationsProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              itemCount: conversations.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _ConversationTile(
                  conversation: conversation,
                  currentUserId: currentUserId,
                );
              },
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
              Text(
                'Error al cargar conversaciones',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.md),
              FilledButton.icon(
                onPressed: () => ref.invalidate(conversationsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final otherUserName = conversation.getOtherUserName(currentUserId);
    final otherUserPhoto = conversation.getOtherUserPhoto(currentUserId);
    final hasUnread = conversation.hasUnreadMessages;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryLight,
            backgroundImage:
                otherUserPhoto != null ? NetworkImage(otherUserPhoto) : null,
            child: otherUserPhoto == null
                ? Text(
                    otherUserName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          if (hasUnread)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
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
            ),
        ],
      ),
      title: Text(
        otherUserName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        conversation.lastMessagePreview,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: hasUnread ? Colors.black87 : Colors.grey[600],
              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            conversation.lastMessageTime,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: hasUnread ? AppColors.primary : Colors.grey[500],
                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
          if (hasUnread) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        context.push('/chat/${conversation.id}');
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';
import 'package:recurseo/features/chat/presentation/providers/chat_providers.dart';

/// Pantalla de chat individual
class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Marcar mensajes como leídos al entrar
    Future.microtask(() => _markAsRead());
  }

  Future<void> _markAsRead() async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.markMessagesAsRead(widget.conversationId);
    ref.invalidate(conversationsProvider);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    final repository = ref.read(chatRepositoryProvider);
    final result = await repository.sendMessage(
      conversationId: widget.conversationId,
      content: content,
    );

    setState(() {
      _isSending = false;
    });

    switch (result) {
      case Success():
        // Refrescar mensajes
        ref.invalidate(conversationMessagesProvider(widget.conversationId));
        ref.invalidate(conversationsProvider);
        // Scroll al final
        _scrollToBottom();
      case Failure(message: final message):
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
        }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync =
        ref.watch(conversationMessagesProvider(widget.conversationId));
    final authState = ref.watch(authNotifierProvider);
    final currentUserId =
        authState is Authenticated ? authState.user.id : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Mostrar opciones
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
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
                          'No hay mensajes aún',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'Envía el primer mensaje',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                // Ordenar mensajes del más reciente al más antiguo
                final sortedMessages = messages.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(AppSizes.md),
                  itemCount: sortedMessages.length,
                  itemBuilder: (context, index) {
                    final message = sortedMessages[index];
                    final isSentByMe = message.isSentByUser(currentUserId);

                    return _MessageBubble(
                      message: message,
                      isSentByMe: isSentByMe,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: AppSizes.md),
                    Text('Error al cargar mensajes',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSizes.sm),
                    Text(error.toString(),
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: AppSizes.md),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(
                          conversationMessagesProvider(widget.conversationId)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Input de mensaje
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSizes.sm),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // TODO: Adjuntar archivo
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.sm,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    onPressed: _isSending ? null : _sendMessage,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSentByMe;

  const _MessageBubble({
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: isSentByMe
                    ? AppColors.primary
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppSizes.radiusMd),
                  topRight: const Radius.circular(AppSizes.radiusMd),
                  bottomLeft: Radius.circular(
                      isSentByMe ? AppSizes.radiusMd : AppSizes.radiusXs),
                  bottomRight: Radius.circular(
                      isSentByMe ? AppSizes.radiusXs : AppSizes.radiusMd),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.timeFormatted,
                        style: TextStyle(
                          color: isSentByMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                      if (isSentByMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead
                              ? AppColors.info
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          if (isSentByMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

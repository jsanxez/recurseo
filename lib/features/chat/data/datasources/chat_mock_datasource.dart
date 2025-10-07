import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/chat/data/models/conversation_model.dart';
import 'package:recurseo/features/chat/data/models/message_model.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';

/// DataSource mock para chat (datos de prueba)
class ChatMockDataSource {
  final _logger = const Logger('ChatMockDataSource');

  // Conversaciones de prueba
  static final _mockConversations = <ConversationModel>[
    ConversationModel(
      id: '1',
      user1Id: '1', // Juan Pérez (cliente)
      user2Id: '2', // María González (proveedor)
      user1Name: 'Juan Pérez',
      user2Name: 'María González',
      unreadCount: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  // Mensajes de prueba
  static final _mockMessages = <MessageModel>[
    // Conversación 1: Juan Pérez <-> María González
    MessageModel(
      id: '1',
      conversationId: '1',
      senderId: '1', // Juan
      content: 'Hola María, vi tu perfil y me interesa tu servicio de plomería.',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MessageModel(
      id: '2',
      conversationId: '1',
      senderId: '2', // María
      content:
          '¡Hola Juan! Gracias por contactarme. Cuéntame, ¿qué problema tienes?',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 23)),
    ),
    MessageModel(
      id: '3',
      conversationId: '1',
      senderId: '1', // Juan
      content:
          'Tengo una fuga en la tubería del baño. El agua está goteando constantemente.',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 20)),
    ),
    MessageModel(
      id: '4',
      conversationId: '1',
      senderId: '2', // María
      content:
          'Entiendo. ¿Podrías enviarme una foto de la fuga para ver qué herramientas necesito llevar?',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 19)),
    ),
    MessageModel(
      id: '5',
      conversationId: '1',
      senderId: '1', // Juan
      content: 'Claro, aquí te envío las fotos',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 18)),
    ),
    MessageModel(
      id: '6',
      conversationId: '1',
      senderId: '2', // María
      content:
          'Perfecto, ya vi las fotos. Puedo ir mañana a las 10am. ¿Te parece bien?',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 17)),
    ),
    MessageModel(
      id: '7',
      conversationId: '1',
      senderId: '1', // Juan
      content: 'Excelente, te espero mañana a esa hora. ¿Cuánto cobrarías?',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 16)),
    ),
    MessageModel(
      id: '8',
      conversationId: '1',
      senderId: '2', // María
      content:
          'Por lo que veo en las fotos, calculo entre \$50 y \$80. Depende del estado de las tuberías.',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 15)),
    ),
    MessageModel(
      id: '9',
      conversationId: '1',
      senderId: '1', // Juan
      content: 'Me parece bien el presupuesto. Nos vemos mañana entonces.',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 14)),
    ),
    MessageModel(
      id: '10',
      conversationId: '1',
      senderId: '2', // María
      content: '¡Perfecto! Te confirmo que llegaré a las 10am. ¡Hasta mañana!',
      type: MessageType.text,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 13)),
    ),
    MessageModel(
      id: '11',
      conversationId: '1',
      senderId: '2', // María
      content: 'Hola Juan, ya estoy llegando a tu dirección.',
      type: MessageType.text,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    MessageModel(
      id: '12',
      conversationId: '1',
      senderId: '2', // María
      content:
          'Ya terminé la reparación. Todo quedó perfecto. El total es \$65.',
      type: MessageType.text,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  /// Obtener conversaciones del usuario
  Future<List<ConversationModel>> getUserConversations(String userId) async {
    _logger.info('Mock: Getting conversations for user $userId');
    await Future.delayed(const Duration(milliseconds: 500));

    final conversations = _mockConversations.where((c) {
      return c.user1Id == userId || c.user2Id == userId;
    }).toList();

    // Actualizar cada conversación con su último mensaje
    final conversationsWithLastMessage = <ConversationModel>[];
    for (var conversation in conversations) {
      final messages =
          _mockMessages.where((m) => m.conversationId == conversation.id);
      if (messages.isNotEmpty) {
        final lastMessage = messages.reduce((a, b) {
          return a.createdAt.isAfter(b.createdAt) ? a : b;
        });

        // Contar mensajes no leídos del otro usuario
        final unreadCount = _mockMessages.where((m) {
          return m.conversationId == conversation.id &&
              m.senderId != userId &&
              !m.isRead;
        }).length;

        conversationsWithLastMessage.add(
          ConversationModel(
            id: conversation.id,
            user1Id: conversation.user1Id,
            user2Id: conversation.user2Id,
            user1Name: conversation.user1Name,
            user2Name: conversation.user2Name,
            user1PhotoUrl: conversation.user1PhotoUrl,
            user2PhotoUrl: conversation.user2PhotoUrl,
            lastMessage: lastMessage,
            unreadCount: unreadCount,
            createdAt: conversation.createdAt,
            updatedAt: lastMessage.createdAt,
          ),
        );
      } else {
        conversationsWithLastMessage.add(conversation);
      }
    }

    // Ordenar por fecha de actualización (más reciente primero)
    conversationsWithLastMessage.sort((a, b) {
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return conversationsWithLastMessage;
  }

  /// Obtener mensajes de una conversación
  Future<List<MessageModel>> getConversationMessages(
      String conversationId) async {
    _logger.info('Mock: Getting messages for conversation $conversationId');
    await Future.delayed(const Duration(milliseconds: 400));

    final messages = _mockMessages
        .where((m) => m.conversationId == conversationId)
        .toList();

    // Ordenar por fecha (más antiguo primero)
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return messages;
  }

  /// Enviar mensaje
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    _logger.info('Mock: Sending message to conversation $conversationId');
    await Future.delayed(const Duration(milliseconds: 600));

    final newMessage = MessageModel(
      id: '${_mockMessages.length + 1}',
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      type: type,
      isRead: false,
      createdAt: DateTime.now(),
    );

    _mockMessages.add(newMessage);

    // Actualizar fecha de última actualización de la conversación
    final conversationIndex =
        _mockConversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final oldConv = _mockConversations[conversationIndex];
      _mockConversations[conversationIndex] = ConversationModel(
        id: oldConv.id,
        user1Id: oldConv.user1Id,
        user2Id: oldConv.user2Id,
        user1Name: oldConv.user1Name,
        user2Name: oldConv.user2Name,
        user1PhotoUrl: oldConv.user1PhotoUrl,
        user2PhotoUrl: oldConv.user2PhotoUrl,
        lastMessage: oldConv.lastMessage,
        unreadCount: oldConv.unreadCount,
        createdAt: oldConv.createdAt,
        updatedAt: DateTime.now(),
      );
    }

    return newMessage;
  }

  /// Marcar mensajes como leídos
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    _logger.info('Mock: Marking messages as read in conversation $conversationId');
    await Future.delayed(const Duration(milliseconds: 300));

    // Marcar todos los mensajes no leídos del otro usuario como leídos
    for (var i = 0; i < _mockMessages.length; i++) {
      if (_mockMessages[i].conversationId == conversationId &&
          _mockMessages[i].senderId != userId &&
          !_mockMessages[i].isRead) {
        final oldMsg = _mockMessages[i];
        _mockMessages[i] = MessageModel(
          id: oldMsg.id,
          conversationId: oldMsg.conversationId,
          senderId: oldMsg.senderId,
          content: oldMsg.content,
          type: oldMsg.type,
          mediaUrl: oldMsg.mediaUrl,
          isRead: true,
          createdAt: oldMsg.createdAt,
        );
      }
    }

    // Actualizar contador de no leídos en la conversación
    final conversationIndex =
        _mockConversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final oldConv = _mockConversations[conversationIndex];
      _mockConversations[conversationIndex] = ConversationModel(
        id: oldConv.id,
        user1Id: oldConv.user1Id,
        user2Id: oldConv.user2Id,
        user1Name: oldConv.user1Name,
        user2Name: oldConv.user2Name,
        user1PhotoUrl: oldConv.user1PhotoUrl,
        user2PhotoUrl: oldConv.user2PhotoUrl,
        lastMessage: oldConv.lastMessage,
        unreadCount: 0,
        createdAt: oldConv.createdAt,
        updatedAt: oldConv.updatedAt,
      );
    }
  }

  /// Obtener o crear conversación entre dos usuarios
  Future<ConversationModel> getOrCreateConversation({
    required String user1Id,
    required String user2Id,
    required String user1Name,
    required String user2Name,
  }) async {
    _logger.info('Mock: Getting or creating conversation between $user1Id and $user2Id');
    await Future.delayed(const Duration(milliseconds: 500));

    // Buscar conversación existente
    final existingConversation = _mockConversations.firstWhere(
      (c) =>
          (c.user1Id == user1Id && c.user2Id == user2Id) ||
          (c.user1Id == user2Id && c.user2Id == user1Id),
      orElse: () {
        // Crear nueva conversación
        final newConversation = ConversationModel(
          id: '${_mockConversations.length + 1}',
          user1Id: user1Id,
          user2Id: user2Id,
          user1Name: user1Name,
          user2Name: user2Name,
          unreadCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _mockConversations.add(newConversation);
        return newConversation;
      },
    );

    return existingConversation;
  }

  /// Obtener número total de mensajes no leídos
  Future<int> getUnreadCount(String userId) async {
    _logger.info('Mock: Getting unread count for user $userId');
    await Future.delayed(const Duration(milliseconds: 300));

    int totalUnread = 0;
    for (var conversation in _mockConversations) {
      if (conversation.user1Id == userId || conversation.user2Id == userId) {
        final unread = _mockMessages.where((m) {
          return m.conversationId == conversation.id &&
              m.senderId != userId &&
              !m.isRead;
        }).length;
        totalUnread += unread;
      }
    }

    return totalUnread;
  }
}

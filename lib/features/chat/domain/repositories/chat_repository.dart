import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/chat/domain/entities/conversation_entity.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';

/// Contrato del repositorio de chat
abstract class ChatRepository {
  /// Obtener conversaciones del usuario
  Future<Result<List<ConversationEntity>>> getUserConversations();

  /// Obtener o crear conversación con otro usuario
  Future<Result<ConversationEntity>> getOrCreateConversation(String otherUserId);

  /// Obtener mensajes de una conversación
  Future<Result<List<MessageEntity>>> getConversationMessages(String conversationId);

  /// Enviar mensaje
  Future<Result<MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
  });

  /// Marcar mensajes como leídos
  Future<Result<void>> markMessagesAsRead(String conversationId);

  /// Eliminar conversación
  Future<Result<void>> deleteConversation(String conversationId);
}

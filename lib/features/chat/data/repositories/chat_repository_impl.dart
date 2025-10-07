import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:recurseo/features/chat/domain/entities/conversation_entity.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';
import 'package:recurseo/features/chat/domain/repositories/chat_repository.dart';

/// Implementación del repositorio de chat
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<ConversationEntity>>> getUserConversations() async {
    try {
      final conversations = await _remoteDataSource.getUserConversations();
      return Success(conversations);
    } catch (e) {
      return Failure(
        message: 'Error al obtener conversaciones',
        error: e,
      );
    }
  }

  @override
  Future<Result<ConversationEntity>> getOrCreateConversation(
      String otherUserId) async {
    try {
      final conversation =
          await _remoteDataSource.getOrCreateConversation(otherUserId);
      return Success(conversation);
    } catch (e) {
      return Failure(
        message: 'Error al crear conversación',
        error: e,
      );
    }
  }

  @override
  Future<Result<List<MessageEntity>>> getConversationMessages(
      String conversationId) async {
    try {
      final messages =
          await _remoteDataSource.getConversationMessages(conversationId);
      return Success(messages);
    } catch (e) {
      return Failure(
        message: 'Error al obtener mensajes',
        error: e,
      );
    }
  }

  @override
  Future<Result<MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
  }) async {
    try {
      final message = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        mediaUrl: mediaUrl,
      );
      return Success(message);
    } catch (e) {
      return Failure(
        message: 'Error al enviar mensaje',
        error: e,
      );
    }
  }

  @override
  Future<Result<void>> markMessagesAsRead(String conversationId) async {
    try {
      await _remoteDataSource.markMessagesAsRead(conversationId);
      return const Success(null);
    } catch (e) {
      return Failure(
        message: 'Error al marcar como leído',
        error: e,
      );
    }
  }

  @override
  Future<Result<void>> deleteConversation(String conversationId) async {
    try {
      await _remoteDataSource.deleteConversation(conversationId);
      return const Success(null);
    } catch (e) {
      return Failure(
        message: 'Error al eliminar conversación',
        error: e,
      );
    }
  }
}

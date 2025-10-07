import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/chat/data/datasources/chat_mock_datasource.dart';
import 'package:recurseo/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:recurseo/features/chat/domain/entities/conversation_entity.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';
import 'package:recurseo/features/chat/domain/repositories/chat_repository.dart';

/// Implementación del repositorio de chat
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource? _remoteDataSource;
  final ChatMockDataSource? _mockDataSource;
  final Ref _ref;
  final _logger = const Logger('ChatRepositoryImpl');

  ChatRepositoryImpl({
    ChatRemoteDataSource? remoteDataSource,
    ChatMockDataSource? mockDataSource,
    required Ref ref,
  })  : _remoteDataSource = remoteDataSource,
        _mockDataSource = mockDataSource,
        _ref = ref {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for chat');
    }
  }

  String get _currentUserId {
    final authState = _ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      return authState.user.id;
    }
    throw Exception('Usuario no autenticado');
  }

  String get _currentUserName {
    final authState = _ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      return authState.user.name;
    }
    throw Exception('Usuario no autenticado');
  }

  @override
  Future<Result<List<ConversationEntity>>> getUserConversations() async {
    try {
      final conversations = AppConfig.useMockData
          ? await _mockDataSource!.getUserConversations(_currentUserId)
          : await _remoteDataSource!.getUserConversations();
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
      final conversation = AppConfig.useMockData
          ? await _mockDataSource!.getOrCreateConversation(
              user1Id: _currentUserId,
              user2Id: otherUserId,
              user1Name: _currentUserName,
              user2Name: 'Usuario', // En mock, no tenemos el nombre real
            )
          : await _remoteDataSource!.getOrCreateConversation(otherUserId);
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
      final messages = AppConfig.useMockData
          ? await _mockDataSource!.getConversationMessages(conversationId)
          : await _remoteDataSource!.getConversationMessages(conversationId);
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
      final message = AppConfig.useMockData
          ? await _mockDataSource!.sendMessage(
              conversationId: conversationId,
              senderId: _currentUserId,
              content: content,
              type: type,
            )
          : await _remoteDataSource!.sendMessage(
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
      if (AppConfig.useMockData) {
        await _mockDataSource!.markMessagesAsRead(
          conversationId: conversationId,
          userId: _currentUserId,
        );
      } else {
        await _remoteDataSource!.markMessagesAsRead(conversationId);
      }
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
      if (AppConfig.useMockData) {
        // En mock, no implementamos delete por ahora
        _logger.info('Mock: Delete conversation not implemented');
      } else {
        await _remoteDataSource!.deleteConversation(conversationId);
      }
      return const Success(null);
    } catch (e) {
      return Failure(
        message: 'Error al eliminar conversación',
        error: e,
      );
    }
  }
}

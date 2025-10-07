import 'package:dio/dio.dart';
import 'package:recurseo/core/config/api_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/chat/data/models/conversation_model.dart';
import 'package:recurseo/features/chat/data/models/message_model.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';

/// DataSource remoto para chat
class ChatRemoteDataSource {
  final Dio _dio;
  final _logger = const Logger('ChatRemoteDataSource');

  ChatRemoteDataSource(this._dio);

  Future<List<ConversationModel>> getUserConversations() async {
    try {
      final response = await _dio.get(ApiConfig.conversations);

      return (response.data as List<dynamic>)
          .map((json) =>
              ConversationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logger.error('Get conversations failed', e);
      throw _handleError(e);
    }
  }

  Future<ConversationModel> getOrCreateConversation(String otherUserId) async {
    try {
      final response = await _dio.post(
        ApiConfig.conversations,
        data: {'other_user_id': otherUserId},
      );

      return ConversationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Get or create conversation failed', e);
      throw _handleError(e);
    }
  }

  Future<List<MessageModel>> getConversationMessages(
      String conversationId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.conversations}/$conversationId/messages',
      );

      return (response.data as List<dynamic>)
          .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logger.error('Get messages failed', e);
      throw _handleError(e);
    }
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.messages,
        data: {
          'conversation_id': conversationId,
          'content': content,
          'type': _typeToString(type),
          if (mediaUrl != null) 'media_url': mediaUrl,
        },
      );

      return MessageModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Send message failed', e);
      throw _handleError(e);
    }
  }

  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      await _dio.put(
        '${ApiConfig.conversations}/$conversationId/read',
      );
    } on DioException catch (e) {
      _logger.error('Mark as read failed', e);
      throw _handleError(e);
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _dio.delete(
        '${ApiConfig.conversations}/$conversationId',
      );
    } on DioException catch (e) {
      _logger.error('Delete conversation failed', e);
      throw _handleError(e);
    }
  }

  String _typeToString(MessageType type) {
    return switch (type) {
      MessageType.text => 'text',
      MessageType.image => 'image',
      MessageType.file => 'file',
    };
  }

  Exception _handleError(DioException e) {
    final message = e.response?.data['message'] as String?;
    return Exception(message ?? 'Error de conexión');
  }
}

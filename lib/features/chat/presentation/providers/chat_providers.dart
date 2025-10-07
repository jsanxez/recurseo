import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/chat/data/datasources/chat_mock_datasource.dart';
import 'package:recurseo/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:recurseo/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:recurseo/features/chat/domain/entities/conversation_entity.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';
import 'package:recurseo/features/chat/domain/repositories/chat_repository.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider del remote datasource
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRemoteDataSource(dio);
});

/// Provider del mock datasource
final chatMockDataSourceProvider = Provider<ChatMockDataSource>((ref) {
  return ChatMockDataSource();
});

/// Provider del repositorio de chat
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  if (AppConfig.useMockData) {
    final mockDataSource = ref.watch(chatMockDataSourceProvider);
    return ChatRepositoryImpl(
      mockDataSource: mockDataSource,
      ref: ref,
    );
  } else {
    final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
    return ChatRepositoryImpl(
      remoteDataSource: remoteDataSource,
      ref: ref,
    );
  }
});

/// Provider de conversaciones del usuario
final conversationsProvider =
    FutureProvider<List<ConversationEntity>>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  final result = await repository.getUserConversations();

  return switch (result) {
    Success(data: final conversations) => conversations,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de mensajes de una conversación
final conversationMessagesProvider = FutureProvider.family<List<MessageEntity>,
    String>((ref, conversationId) async {
  final repository = ref.watch(chatRepositoryProvider);
  final result = await repository.getConversationMessages(conversationId);

  return switch (result) {
    Success(data: final messages) => messages,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider para contar conversaciones con mensajes no leídos
final unreadConversationsCountProvider = FutureProvider<int>((ref) async {
  final conversations = await ref.watch(conversationsProvider.future);
  return conversations.where((c) => c.hasUnreadMessages).length;
});

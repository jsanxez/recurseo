import 'package:recurseo/features/chat/data/models/message_model.dart';
import 'package:recurseo/features/chat/domain/entities/conversation_entity.dart';

/// Modelo de conversación para serialización
class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.user1Id,
    required super.user2Id,
    required super.user1Name,
    required super.user2Name,
    super.user1PhotoUrl,
    super.user2PhotoUrl,
    super.lastMessage,
    super.unreadCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      user1Name: json['user1_name'] as String,
      user2Name: json['user2_name'] as String,
      user1PhotoUrl: json['user1_photo_url'] as String?,
      user2PhotoUrl: json['user2_photo_url'] as String?,
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'user1_name': user1Name,
      'user2_name': user2Name,
      'user1_photo_url': user1PhotoUrl,
      'user2_photo_url': user2PhotoUrl,
      'last_message': lastMessage != null
          ? MessageModel.fromEntity(lastMessage!).toJson()
          : null,
      'unread_count': unreadCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      user1Id: entity.user1Id,
      user2Id: entity.user2Id,
      user1Name: entity.user1Name,
      user2Name: entity.user2Name,
      user1PhotoUrl: entity.user1PhotoUrl,
      user2PhotoUrl: entity.user2PhotoUrl,
      lastMessage: entity.lastMessage,
      unreadCount: entity.unreadCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

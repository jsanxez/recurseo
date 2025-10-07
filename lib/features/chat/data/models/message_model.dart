import 'package:recurseo/features/chat/domain/entities/message_entity.dart';

/// Modelo de mensaje para serialización
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.content,
    super.type,
    super.mediaUrl,
    required super.isRead,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      type: _parseType(json['type'] as String?),
      mediaUrl: json['media_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'type': _typeToString(type),
      'media_url': mediaUrl,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: entity.content,
      type: entity.type,
      mediaUrl: entity.mediaUrl,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  static MessageType _parseType(String? type) {
    return switch (type?.toLowerCase()) {
      'text' => MessageType.text,
      'image' => MessageType.image,
      'file' => MessageType.file,
      _ => MessageType.text,
    };
  }

  static String _typeToString(MessageType type) {
    return switch (type) {
      MessageType.text => 'text',
      MessageType.image => 'image',
      MessageType.file => 'file',
    };
  }
}

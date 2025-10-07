import 'package:equatable/equatable.dart';

/// Tipo de mensaje
enum MessageType {
  text,
  image,
  file,
}

/// Entidad de mensaje en una conversación
class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final String? mediaUrl;
  final bool isRead;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
    this.mediaUrl,
    required this.isRead,
    required this.createdAt,
  });

  /// Verificar si el mensaje es del usuario actual
  bool isSentByUser(String userId) => senderId == userId;

  /// Obtener hora formateada
  String get timeFormatted {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  MessageEntity copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    String? mediaUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        type,
        mediaUrl,
        isRead,
        createdAt,
      ];
}

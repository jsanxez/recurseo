import 'package:equatable/equatable.dart';
import 'package:recurseo/features/chat/domain/entities/message_entity.dart';

/// Entidad de conversación entre dos usuarios
class ConversationEntity extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final String user1Name;
  final String user2Name;
  final String? user1PhotoUrl;
  final String? user2PhotoUrl;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationEntity({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    this.user1PhotoUrl,
    this.user2PhotoUrl,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Obtener nombre del otro usuario
  String getOtherUserName(String currentUserId) {
    return currentUserId == user1Id ? user2Name : user1Name;
  }

  /// Obtener foto del otro usuario
  String? getOtherUserPhoto(String currentUserId) {
    return currentUserId == user1Id ? user2PhotoUrl : user1PhotoUrl;
  }

  /// Obtener ID del otro usuario
  String getOtherUserId(String currentUserId) {
    return currentUserId == user1Id ? user2Id : user1Id;
  }

  /// Verificar si hay mensajes no leídos
  bool get hasUnreadMessages => unreadCount > 0;

  /// Obtener preview del último mensaje
  String get lastMessagePreview {
    if (lastMessage == null) return 'Sin mensajes';

    return switch (lastMessage!.type) {
      MessageType.text => lastMessage!.content,
      MessageType.image => '📷 Imagen',
      MessageType.file => '📎 Archivo',
    };
  }

  /// Obtener tiempo formateado del último mensaje
  String get lastMessageTime {
    if (lastMessage == null) return '';

    final now = DateTime.now();
    final diff = now.difference(lastMessage!.createdAt);

    if (diff.inDays > 0) {
      return '${lastMessage!.createdAt.day}/${lastMessage!.createdAt.month}';
    } else if (diff.inHours > 0) {
      return 'Hace ${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return 'Hace ${diff.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }

  ConversationEntity copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    String? user1Name,
    String? user2Name,
    String? user1PhotoUrl,
    String? user2PhotoUrl,
    MessageEntity? lastMessage,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      user1Name: user1Name ?? this.user1Name,
      user2Name: user2Name ?? this.user2Name,
      user1PhotoUrl: user1PhotoUrl ?? this.user1PhotoUrl,
      user2PhotoUrl: user2PhotoUrl ?? this.user2PhotoUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        user1Name,
        user2Name,
        user1PhotoUrl,
        user2PhotoUrl,
        lastMessage,
        unreadCount,
        createdAt,
        updatedAt,
      ];
}

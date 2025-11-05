import 'package:android_chat_app/features/chat/domain/entities/room.dart';

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
    required super.lastMessage,
    required super.lastMessageSentAt,
    required super.unreadMessagesCount,
  });

  factory RoomModel.fromEntity(Room room) {
    return RoomModel(
      id: room.id,
      username: room.username,
      displayName: room.displayName,
      avatarUrl: room.avatarUrl,
      lastMessage: room.lastMessage,
      lastMessageSentAt: room.lastMessageSentAt,
      unreadMessagesCount: room.unreadMessagesCount,
    );
  }

  Room toEntity() {
    return Room(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage,
      lastMessageSentAt: lastMessageSentAt,
      unreadMessagesCount: unreadMessagesCount,
    );
  }
}

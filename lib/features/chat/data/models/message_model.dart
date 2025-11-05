import 'package:android_chat_app/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.senderId,
    required super.isSentByMe,
  });

  factory ChatRoomModel.fromEntity(ChatRoom chatRoom) {
    return ChatRoomModel(
      id: chatRoom.id,
      content: chatRoom.content,
      sentAt: chatRoom.sentAt,
      senderId: chatRoom.senderId,
      isSentByMe: chatRoom.isSentByMe,
    );
  }

  ChatRoom toEntity() {
    return ChatRoom(
      id: id,
      content: content,
      sentAt: sentAt,
      senderId: senderId,
      isSentByMe: isSentByMe,
    );
  }
}

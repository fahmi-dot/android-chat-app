import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';

class ChatListModel extends ChatList {
  const ChatListModel({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
  });

  factory ChatListModel.fromEntity(ChatList chatList) {
    return ChatListModel(
      id: chatList.id,
      username: chatList.username,
      displayName: chatList.displayName,
      avatarUrl: chatList.avatarUrl,
    );
  }

  ChatList toEntity() {
    return ChatList(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}

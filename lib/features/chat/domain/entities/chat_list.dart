import 'package:equatable/equatable.dart';

class ChatList extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageSentAt;
  final int unreadMessagesCount;

  const ChatList({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageSentAt,
    required this.unreadMessagesCount,
  });

  ChatList copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? lastMessage,
    DateTime? lastMessageSentAt,
    int? unreadMessagesCount,
  }) {
    return ChatList(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    avatarUrl,
    lastMessage,
    lastMessageSentAt,
    unreadMessagesCount,
  ];
}

import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageSentAt;
  final int unreadMessagesCount;

  const Room({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageSentAt,
    required this.unreadMessagesCount,
  });

  Room copyWith({
    int? unreadMessagesCount,
  }) {
    return Room(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage,
      lastMessageSentAt: lastMessageSentAt,
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

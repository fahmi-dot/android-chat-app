import 'package:equatable/equatable.dart';

class ChatList extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;

  const ChatList({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
  });

  ChatList copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
  }) {
    return ChatList(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, username, displayName, avatarUrl];
}

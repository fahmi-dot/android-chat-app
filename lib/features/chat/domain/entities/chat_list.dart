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

  @override
  List<Object?> get props => [id, username, displayName, avatarUrl];
}

import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String id;
  final String content;
  final String sentAt;
  final String senderId;

  const ChatRoom({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.senderId,
  });

  ChatRoom copyWith({
    String? content,
  }) {
    return ChatRoom(
      id: id, 
      content: content ?? this.content, 
      sentAt: sentAt, 
      senderId: senderId
    );
  }
  
  @override
  List<Object?> get props => [id, content, sentAt, senderId];
}
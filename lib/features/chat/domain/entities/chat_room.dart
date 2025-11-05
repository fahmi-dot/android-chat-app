import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String id;
  final String content;
  final DateTime sentAt;
  final String senderId;
  final bool isSentByMe;

  const ChatRoom({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.senderId,
    required this.isSentByMe
  });

  ChatRoom copyWith({
    String? content,
  }) {
    return ChatRoom(
      id: id, 
      content: content ?? this.content, 
      sentAt: sentAt, 
      senderId: senderId,
      isSentByMe: isSentByMe
    );
  }
  
  @override
  List<Object?> get props => [id, content, sentAt, senderId, isSentByMe];
}
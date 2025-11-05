import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final DateTime sentAt;
  final String senderId;
  final bool isSentByMe;

  const Message({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.senderId,
    required this.isSentByMe
  });

  Message copyWith({
    String? content,
  }) {
    return Message(
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
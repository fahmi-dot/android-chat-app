import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? id;
  final String content;
  final DateTime sentAt;
  final bool isRead;
  final String senderId;
  final bool isSentByMe;

  const Message({
    this.id,
    required this.content,
    required this.sentAt,
    required this.isRead,
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
      isRead: isRead,
      senderId: senderId,
      isSentByMe: isSentByMe
    );
  }
  
  @override
  List<Object?> get props => [id, content, sentAt, isRead, senderId, isSentByMe];
}
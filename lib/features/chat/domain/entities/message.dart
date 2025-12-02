import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String roomId;
  final String content;
  final String? mediaUrl;
  final DateTime sentAt;
  final bool isRead;
  final String senderId;
  final bool isSentByMe;

  const Message({
    required this.id,
    required this.roomId,
    required this.content,
    this.mediaUrl,
    required this.sentAt,
    required this.isRead,
    required this.senderId,
    required this.isSentByMe,
  });

  Message copyWith({String? content}) {
    return Message(
      id: id,
      roomId: roomId,
      content: content ?? this.content,
      mediaUrl: mediaUrl,
      sentAt: sentAt,
      isRead: isRead,
      senderId: senderId,
      isSentByMe: isSentByMe,
    );
  }

  @override
  List<Object?> get props => [
    id,
    roomId,
    content,
    mediaUrl,
    sentAt,
    isRead,
    senderId,
    isSentByMe,
  ];
}

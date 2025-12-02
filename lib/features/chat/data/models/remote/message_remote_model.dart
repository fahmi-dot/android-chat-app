import 'package:android_chat_app/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.roomId,
    required super.content,
    required super.mediaUrl,
    required super.sentAt,
    required super.isRead,
    required super.senderId,
    required super.isSentByMe
  });

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      roomId: message.roomId,
      content: message.content,
      mediaUrl: message.mediaUrl,
      sentAt: message.sentAt,
      isRead: message.isRead,
      senderId: message.senderId,
      isSentByMe: message.isSentByMe,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json, String userId) {
    return MessageModel(
      id: json['id'],
      roomId: json['roomId'],
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? json['read'] ?? false,
      senderId: json['senderId'],
      isSentByMe: json['senderId'] == userId,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      roomId: roomId,
      content: content,
      mediaUrl: mediaUrl,
      sentAt: sentAt,
      isRead: isRead,
      senderId: senderId,
      isSentByMe: isSentByMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'content': content,
      'mediaUrl': mediaUrl,
      'sentAt': sentAt,
      'isRead': isRead,
      'senderId': senderId,
      'isSentByMe': isSentByMe,
    };
  }
}

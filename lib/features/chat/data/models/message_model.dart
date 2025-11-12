import 'package:android_chat_app/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.isRead,
    required super.senderId,
    required super.isSentByMe,
  });

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      content: message.content,
      sentAt: message.sentAt,
      isRead: message.isRead,
      senderId: message.senderId,
      isSentByMe: message.isSentByMe,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json, String userId) {
    return MessageModel(
      id: json['id'] ?? DateTime.now().toString(),
      content: json['content'] ?? '',
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      senderId: json['senderId'] ?? '',
      isSentByMe: json['senderId'] == userId,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      content: content,
      sentAt: sentAt,
      isRead: isRead,
      senderId: senderId,
      isSentByMe: isSentByMe,
    );
  }
}

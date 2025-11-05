import 'package:android_chat_app/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.senderId,
    required super.isSentByMe,
  });

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      content: message.content,
      sentAt: message.sentAt,
      senderId: message.senderId,
      isSentByMe: message.isSentByMe,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      content: content,
      sentAt: sentAt,
      senderId: senderId,
      isSentByMe: isSentByMe,
    );
  }
}

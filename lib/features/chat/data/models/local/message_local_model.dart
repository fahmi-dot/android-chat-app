import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:hive/hive.dart';

part 'message_local_model.g.dart';

@HiveType(typeId: 1)
class MessageLocalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String roomId;
  
  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? mediaUrl;
  
  @HiveField(4)
  final DateTime sentAt;
  
  @HiveField(5)
  final bool isRead;
  
  @HiveField(6)
  final String senderId;
  
  @HiveField(7)
  final bool isSentByMe;
  
  @HiveField(8)
  final String? localMediaPath;

  MessageLocalModel({
    required this.id,
    required this.roomId,
    required this.content,
    this.mediaUrl,
    required this.sentAt,
    required this.isRead,
    required this.senderId,
    required this.isSentByMe,
    this.localMediaPath,
  });

  factory MessageLocalModel.fromEntity(Message message) {
    return MessageLocalModel(
      id: message.id,
      roomId: message.roomId,
      content: message.content,
      mediaUrl: message.mediaUrl,
      sentAt: message.sentAt,
      isRead: message.isRead,
      senderId: message.senderId,
      isSentByMe: message.isSentByMe,
      localMediaPath: null,
    );
  }

  factory MessageLocalModel.fromJson(Map<String, dynamic> json) {
    return MessageLocalModel(
      id: json['id'],
      roomId: json['roomId'],
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      sentAt: DateTime.parse(json['sentAt']),
      isRead: json['isRead'] ?? json['read'] ?? false,
      senderId: json['senderId'],
      isSentByMe: json['isSentByMe'] ?? json['sentByMe'] ?? false,
      localMediaPath: json['localMediaPath']
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

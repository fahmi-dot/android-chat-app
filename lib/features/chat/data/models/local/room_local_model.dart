import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:hive/hive.dart';

part 'room_local_model.g.dart';

@HiveType(typeId: 2)
class RoomLocalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;
  
  @HiveField(2)
  final String displayName;

  @HiveField(3)
  final String avatarUrl;
  
  @HiveField(4)
  final String lastMessage;
  
  @HiveField(5)
  final DateTime lastMessageSentAt;
  
  @HiveField(6)
  final int unreadMessagesCount;
  
  RoomLocalModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageSentAt,
    required this.unreadMessagesCount,
  });

  factory RoomLocalModel.fromEntity(Room room) {
    return RoomLocalModel(
      id: room.id,
      username: room.username,
      displayName: room.displayName,
      avatarUrl: room.avatarUrl,
      lastMessage: room.lastMessage,
      lastMessageSentAt: room.lastMessageSentAt,
      unreadMessagesCount: room.unreadMessagesCount,
    );
  }

  factory RoomLocalModel.fromJson(Map<String, dynamic> json) {
    return RoomLocalModel(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      lastMessage: json['lastMessage'],
      lastMessageSentAt: DateTime.parse(json['lastMessageSentAt']),
      unreadMessagesCount: json['unreadMessagesCount'],
    );
  }

  Room toEntity() {
    return Room(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage,
      lastMessageSentAt: lastMessageSentAt,
      unreadMessagesCount: unreadMessagesCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'lastMessageSentAt': lastMessageSentAt,
      'unreadMessagesCount': unreadMessagesCount,
    };
  }
}

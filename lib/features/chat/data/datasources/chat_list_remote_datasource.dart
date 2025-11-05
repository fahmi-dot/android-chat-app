import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/room_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:dio/dio.dart';

abstract class ChatListRemoteDataSource {
  Future<List<Room>> getChatRoomList();
  Future<Room> getChatRoomDetail(String roomId);
}

class ChatListRemoteDataSourceImpl implements ChatListRemoteDataSource {
  final ApiClient api;
  final String currentUsername;

  ChatListRemoteDataSourceImpl({
    required this.api,
    required this.currentUsername,
  });

  @override
  Future<List<Room>> getChatRoomList() async {
    try {
      final response = await api.get('/chat/room');
      final data = response.data['data'] as List;

      return data.map((room) {
        final participants = room['participants'] as List;
        final target = participants.firstWhere(
          (p) => p['username'] != currentUsername,
          orElse: () => null,
        );

        return RoomModel(
          id: room['id'],
          username: target?['username'] ?? '',
          displayName: target?['displayName'] ?? '',
          avatarUrl: target?['avatarUrl'] ?? '',
          lastMessage: room['lastMessage'] ?? '',
          lastMessageSentAt: room['lastMessageSentAt'] != null
              ? DateTime.parse(room['lastMessageSentAt'])
              : DateTime.now(),
          unreadMessagesCount: room['unreadMessagesCount'],
        ).toEntity();
      }).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get chat room list: $e');
    }
  }
  
  @override
  Future<Room> getChatRoomDetail(String roomId) async {
    try {
      final response = await api.get('/chat/room/$roomId');
      final data = response.data['data'];
      final participants = data['participants'] as List;
      final target = participants.firstWhere(
        (p) => p['username'] != currentUsername,
        orElse: () => null,
      );

      return RoomModel(
        id: data['id'],
        username: target?['username'],
        displayName: target?['displayName'],
        avatarUrl: target?['avatarUrl'],
        lastMessage: data['lastMessage'],
        lastMessageSentAt: data['lastMessageSentAt'] != null
              ? DateTime.parse(data['lastMessageSentAt'])
              : DateTime.now(),
        unreadMessagesCount: data['unreadMessagesCount'],
      ).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to get chat room detail: $e');
    }
  }
}

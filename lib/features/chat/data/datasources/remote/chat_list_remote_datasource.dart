import 'package:dio/dio.dart';

import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/room_model.dart';

abstract class ChatListRemoteDataSource {
  Future<List<RoomModel>> getChatRooms();
}

class ChatListRemoteDataSourceImpl implements ChatListRemoteDataSource {
  final ApiClient api;

  ChatListRemoteDataSourceImpl({required this.api});

  @override
  Future<List<RoomModel>> getChatRooms() async {
    try {
      final response = await api.get('/chat/rooms');
      final data = response.data['data'] as List;

      return data.map((room) {
        final participants = (room['participants'] as List).first;

        return RoomModel(
          id: room['id'],
          username: participants['username'] ?? '',
          displayName: participants['displayName'] ?? '',
          avatarUrl: participants['avatarUrl'] ?? '',
          lastMessage: room['lastMessage'] ?? '',
          lastMessageSentAt: room['lastMessageSentAt'] != null
              ? DateTime.parse(room['lastMessageSentAt'])
              : DateTime.now(),
          unreadMessagesCount: room['unreadMessagesCount'] ?? 0,
        );
      }).toList();
    } on DioException {
      throw Exception(AppStrings.somethingWentWrongMessage);
    }
  }
}

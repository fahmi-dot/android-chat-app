import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/chat_list_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';

abstract class ChatListRemoteDataSource {
  Future<List<ChatList>> getRooms();
}

class ChatListRemoteDataSourceImpl implements ChatListRemoteDataSource {
  final ApiClient api;
  final String currentUsername;

  ChatListRemoteDataSourceImpl({required this.api, required this.currentUsername});

  @override
  Future<List<ChatList>> getRooms() async {
    final response = await api.get('/chat/list');
    final data = response.data['data'] as List;

    return data.map((room) {
      final participants = room['participants'] as List;
      final target = participants.firstWhere(
        (p) => p['username'] != currentUsername,
        orElse: () => null,
      );

      return ChatListModel(
        id: room['id'],
        username: target?['username'] ?? '',
        displayName: target?['displayName'] ?? '',
        avatarUrl: target?['avatarUrl'] ?? '',
      ).toEntity();
    }).toList();
  }
}

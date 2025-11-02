import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/chat_list_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';

abstract class ChatListRemoteDataSource {
  Future<List<ChatList>> list();
}

class ChatListRemoteDataSourceImpl implements ChatListRemoteDataSource {
  final ApiClient api;
  final String currentUsername;

  ChatListRemoteDataSourceImpl({required this.api, required this.currentUsername});

  @override
  Future<List<ChatList>> list() async {
    final response = await api.get('/chat/list');
    final data = response.data['data'] as List;

    return data.map((chatListData) {
      final participants = chatListData['participants'] as List;
      final target = participants.firstWhere(
        (p) => p['username'] != currentUsername,
        orElse: () => null,
      );

      return ChatListModel(
        id: chatListData['id'],
        username: target?['username'] ?? '',
        displayName: target?['displayName'] ?? '',
        avatarUrl: target?['avatarUrl'] ?? '',
      );
    }).toList();
  }
}

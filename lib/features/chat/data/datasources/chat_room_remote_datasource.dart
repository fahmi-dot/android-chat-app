import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/chat_room_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_room.dart';
import 'package:dio/dio.dart';

abstract class ChatRoomRemoteDataSource {
  Future<List<ChatRoom>> getMessages(String roomId);
}

class ChatRoomRemoteDataSourceImpl extends ChatRoomRemoteDataSource {
  final ApiClient api;

  ChatRoomRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ChatRoom>> getMessages(String roomId) async {
    try {
      final response = await api.get('/chat/$roomId/messages');
      final data = response.data['data'] as List;

      return data.map((message) {
        return ChatRoomModel(
          id: message['id'],
          content: message['content'],
          sentAt: message['sentAt'] 
              ? DateTime.parse(message['sentAt'])
              : DateTime.now(),
          senderId: message['senderId'],
          isSentByMe: true,
        ).toEntity();
      }).toList();
    } on DioException catch (e) {
      throw Exception('Gagal mendapatkan messages: $e');
    }
  }
}

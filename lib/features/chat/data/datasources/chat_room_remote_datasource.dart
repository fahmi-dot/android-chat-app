import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/message_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:dio/dio.dart';

abstract class ChatRoomRemoteDataSource {
  Future<List<Message>> getChatMessages(String roomId);
}

class ChatRoomRemoteDataSourceImpl extends ChatRoomRemoteDataSource {
  final ApiClient api;

  ChatRoomRemoteDataSourceImpl({required this.api});

  @override
  Future<List<Message>> getChatMessages(String roomId) async {
    try {
      final response = await api.get('/chat/$roomId/messages');
      final data = response.data['data'] as List;

      return data.map((message) {
        return MessageModel(
          id: message['id'],
          content: message['content'],
          sentAt: message['sentAt'] != null
              ? DateTime.parse(message['sentAt'])
              : DateTime.now(),
          senderId: message['senderId'],
          isSentByMe: true,
        ).toEntity();
      }).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get chat messages: $e');
    }
  }
}

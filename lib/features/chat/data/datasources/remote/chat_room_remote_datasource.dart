import 'package:dio/dio.dart';

import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/models/remote/message_remote_model.dart';

abstract class ChatRoomRemoteDataSource {
  Future<List<MessageRemoteModel>> getRoomMessages(String roomId, String userId);
  Future<void> markAsRead(String roomId);
}

class ChatRoomRemoteDataSourceImpl extends ChatRoomRemoteDataSource {
  final ApiClient api;

  ChatRoomRemoteDataSourceImpl({required this.api});

  @override
  Future<List<MessageRemoteModel>> getRoomMessages(String roomId, String userId) async {
    try {
      final response = await api.get('/chat/rooms/$roomId/messages');
      final data = response.data['data'] as List;

      return data.map((message) =>
        MessageRemoteModel.fromJson(message, userId)
      ).toList();
    } on DioException {
      throw Exception(AppStrings.somethingWentWrongMessage);
    }
  }

  @override
  Future<void> markAsRead(String roomId) async {
    try {
      await api.patch('/chat/rooms/$roomId/messages');
    } on DioException {
      throw Exception(AppStrings.somethingWentWrongMessage);
    }
  }
}

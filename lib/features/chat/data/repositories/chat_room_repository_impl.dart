import 'dart:async';

import 'package:android_chat_app/features/chat/data/datasources/remote/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/datasources/local/chat_room_local_datasource.dart';
import 'package:android_chat_app/features/chat/data/models/local/message_local_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRoomRemoteDataSource chatRoomRemoteDataSource;
  final ChatRoomLocalDataSource chatRoomLocalDataSource;

  ChatRoomRepositoryImpl({
    required this.chatRoomRemoteDataSource,
    required this.chatRoomLocalDataSource,
  });
  
  @override
  Future<List<Message>> getRoomMessages(String roomId, String userId) async {
    final messageLocalModels = await chatRoomLocalDataSource.getRoomMessages(roomId);
    
    if (messageLocalModels.isNotEmpty) {
      unawaited(_getFromRemote(roomId, userId));
      
      return messageLocalModels.map((message) => message.toEntity()).toList();
    }

    return await _getFromRemote(roomId, userId);
  }

  @override
  Future<void> markAsRead(String roomId) async {
    return await chatRoomRemoteDataSource.markAsRead(roomId);
  }

  Future<List<Message>> _getFromRemote(String roomId, String userId) async {
    final messageRemoteModels = await chatRoomRemoteDataSource.getRoomMessages(roomId, userId);
    
    for (final remote in messageRemoteModels) {
      final messageLocalModel = MessageLocalModel.fromEntity(remote.toEntity());

      await chatRoomLocalDataSource.upsertRoomMessage(messageLocalModel);
    }

    return messageRemoteModels.map((msg) => msg.toEntity()).toList();
  }
}
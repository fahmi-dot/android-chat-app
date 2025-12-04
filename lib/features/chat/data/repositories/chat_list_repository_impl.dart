import 'dart:async';

import 'package:android_chat_app/features/chat/data/datasources/local/chat_list_local_datasource.dart';
import 'package:android_chat_app/features/chat/data/datasources/remote/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/models/local/room_local_model.dart';
import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  final ChatListRemoteDataSource chatListRemoteDataSource;
  final ChatListLocalDataSource chatListLocalDataSource;

  ChatListRepositoryImpl({
    required this.chatListRemoteDataSource,
    required this.chatListLocalDataSource,
  });

  @override
  Future<List<Room>> getChatRooms() async {
    final roomLocaModels = await chatListRemoteDataSource.getChatRooms();

    if (roomLocaModels.isNotEmpty) {
      unawaited(_getFromRemote());

      return roomLocaModels.map((room) => room.toEntity()).toList();
    }

    return await _getFromRemote();
  }

  @override
  Future<List<Room>> searchChatRooms(String query) async {
    final roomLocalModels = await chatListLocalDataSource.searchChatRooms(query);

    if (roomLocalModels.isNotEmpty) {
      return roomLocalModels.map((room) => room.toEntity()).toList();
    }

    return [];
  }

  Future<List<Room>> _getFromRemote() async {
    final roomRemoteModels = await chatListRemoteDataSource.getChatRooms();
    
    for (final remote in roomRemoteModels) {
      final roomLocalModel = RoomLocalModel.fromEntity(remote.toEntity());

      await chatListLocalDataSource.upsertChatRoom(roomLocalModel);
    }

    return roomRemoteModels.map((room) => room.toEntity()).toList();
  }
}

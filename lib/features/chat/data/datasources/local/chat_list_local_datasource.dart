import 'package:android_chat_app/core/local/hive_service.dart';
import 'package:android_chat_app/core/local/sqlite_service.dart';
import 'package:android_chat_app/features/chat/data/models/local/room_local_model.dart';

abstract class ChatListLocalDataSource {
  Future<void> upsertChatRoom(RoomLocalModel room);
  Future<List<RoomLocalModel>> getChatRooms();
  Future<List<RoomLocalModel>> searchChatRooms(String query);
  Future<void> deleteChatRoom(String id);
}

class ChatListLocalDataSourceImpl implements ChatListLocalDataSource {
  final HiveService hiveService;
  final SqliteService sqliteService;

  ChatListLocalDataSourceImpl(this.hiveService, this.sqliteService);

  @override
  Future<void> upsertChatRoom(RoomLocalModel room) async {
    await hiveService.upsertRoom(room);
  }

  @override
  Future<List<RoomLocalModel>> getChatRooms() async {
    return hiveService.getChatRooms();
  }

  @override
  Future<List<RoomLocalModel>> searchChatRooms(String query) async {
    return hiveService.searchChatRooms(query);
  }

  @override
  Future<void> deleteChatRoom(String id) async {
    await hiveService.deleteChatRoom(id);
  }
}
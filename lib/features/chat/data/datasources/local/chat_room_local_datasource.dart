import 'package:android_chat_app/core/local/hive_service.dart';
import 'package:android_chat_app/core/local/sqlite_service.dart';
import 'package:android_chat_app/features/chat/data/models/local/message_local_model.dart';

abstract class ChatRoomLocalDataSource {
  Future<void> upsertRoomMessage(MessageLocalModel message);
  Future<List<MessageLocalModel>> getRoomMessages(String roomId);
  Future<void> deleteRoomMessage(String id);
}

class ChatRoomLocalDataSourceImpl extends ChatRoomLocalDataSource {
  final HiveService hiveService;
  final SqliteService sqliteService;

  ChatRoomLocalDataSourceImpl(this.hiveService, this.sqliteService);

  @override
  Future<void> upsertRoomMessage(MessageLocalModel message) async {
    await hiveService.upsertMessage(message);
  }

  @override
  Future<List<MessageLocalModel>> getRoomMessages(String roomId) async {
    return hiveService.getRoomMessages(roomId);
  }

  @override
  Future<void> deleteRoomMessage(String id) async {
    await hiveService.deleteRoomMessage(id);
  }
}
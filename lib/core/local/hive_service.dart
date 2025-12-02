import 'package:hive_flutter/hive_flutter.dart';

import 'package:android_chat_app/features/chat/data/models/local/message_local_model.dart';
import 'package:android_chat_app/features/chat/data/models/local/room_local_model.dart';

class HiveService {
  String chatRoomBoxName = 'chat_rooms';
  String roomMessageBoxName = 'room_messages';

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MessageLocalModelAdapter());
    Hive.registerAdapter(RoomLocalModelAdapter());

    assert(() {
      Hive.deleteBoxFromDisk(chatRoomBoxName);
      Hive.deleteBoxFromDisk(roomMessageBoxName);
      return true;
    }());
    
    if (!Hive.isBoxOpen(chatRoomBoxName)) {
      await Hive.openBox<RoomLocalModel>(chatRoomBoxName);
    }
    if (!Hive.isBoxOpen(roomMessageBoxName)) {
      await Hive.openBox<MessageLocalModel>(roomMessageBoxName);
    }
  }

  Box<RoomLocalModel> get chatRoomBox {
    return Hive.box<RoomLocalModel>(chatRoomBoxName);
  }

  Box<MessageLocalModel> get roomMessageBox {
    return Hive.box<MessageLocalModel>(roomMessageBoxName);
  }

  Future<void> upsertRoom(RoomLocalModel room) async {
    await chatRoomBox.put(room.id, room);
  }

  Future<void> upsertMessage(MessageLocalModel message) async {
    await roomMessageBox.put(message.id, message);
  }

  List<RoomLocalModel> getChatRooms() {
    return chatRoomBox.values.toList()
        ..sort((a, b) => 
          b.lastMessageSentAt.compareTo(a.lastMessageSentAt)
        );
  }

  List<RoomLocalModel> searchChatRooms(String query) {
    if (query.isEmpty) return getChatRooms();

    return chatRoomBox.values
        .where((r) => r.username == query).toList()
        ..sort((a, b) => 
          b.lastMessageSentAt.compareTo(a.lastMessageSentAt)
        );
  }

  List<MessageLocalModel> getRoomMessages(String roomId) {
    return roomMessageBox.values
        .where((m) => m.roomId == roomId).toList()
        ..sort((a, b) => 
          b.sentAt.compareTo(a.sentAt)
        );
  }

  Future<void> deleteChatRoom(String id) async {
    await chatRoomBox.delete(id);
  }

  Future<void> deleteRoomMessage(String id) async {
    await roomMessageBox.delete(id);
  }
}
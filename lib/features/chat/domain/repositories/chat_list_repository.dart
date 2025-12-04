import 'package:android_chat_app/features/chat/domain/entities/room.dart';

abstract class ChatListRepository {
  Future<List<Room>> getChatRooms();
  Future<List<Room>> searchChatRooms(String query);
}
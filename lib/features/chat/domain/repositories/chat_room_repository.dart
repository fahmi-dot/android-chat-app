import 'package:android_chat_app/features/chat/domain/entities/chat_room.dart';

abstract class ChatRoomRepository {
  Future<List<ChatRoom>> getMessages(String roomId);
}
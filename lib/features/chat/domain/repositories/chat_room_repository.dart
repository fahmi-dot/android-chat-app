import 'package:android_chat_app/features/chat/domain/entities/message.dart';

abstract class ChatRoomRepository {
  Future<List<Message>> getChatMessages(String roomId, String userId);
  Future<void> markAsRead(String roomId);
}
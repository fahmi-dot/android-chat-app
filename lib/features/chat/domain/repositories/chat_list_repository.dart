import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';

abstract class ChatListRepository {
  Future<List<ChatList>> getRooms();
}
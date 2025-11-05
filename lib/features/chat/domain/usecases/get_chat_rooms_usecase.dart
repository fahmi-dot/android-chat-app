import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class GetChatRoomsUseCase {
  final ChatListRepository _chatListRepository;

  GetChatRoomsUseCase(this._chatListRepository);

  Future<List<Room>> execute() {
    return _chatListRepository.getChatRooms();
  }
}
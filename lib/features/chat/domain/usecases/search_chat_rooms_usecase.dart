import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class SearchChatRoomsUseCase {
  final ChatListRepository _chatListRepository;

  SearchChatRoomsUseCase(this._chatListRepository);

  Future<List<Room>> execute(String query) async {
    return await _chatListRepository.searchChatRooms(query);
  }
}
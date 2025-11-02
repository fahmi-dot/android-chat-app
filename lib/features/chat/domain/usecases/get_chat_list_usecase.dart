import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class GetChatListUseCase {
  final ChatListRepository _chatListRepository;

  GetChatListUseCase(this._chatListRepository);

  Future<List<ChatList>> execute() {
    return _chatListRepository.getRooms();
  }
}
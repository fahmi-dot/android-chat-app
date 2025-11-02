import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class GetChatListUsecase {
  final ChatListRepository _chatListRepository;

  GetChatListUsecase(this._chatListRepository);

  Future<List<ChatList>> execute() {
    return _chatListRepository.list();
  }
}
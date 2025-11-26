import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class MarkAsReadUseCase {
  final ChatListRepository _chatListRepository;

  MarkAsReadUseCase(this._chatListRepository);

  Future<void> execute(String roomId) async {
    await _chatListRepository.markAsRead(roomId);
  }
}
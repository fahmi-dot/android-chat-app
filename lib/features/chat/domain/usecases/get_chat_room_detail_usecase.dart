import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class GetChatRoomDetailUseCase {
  final ChatListRepository _chatListRepository;

  GetChatRoomDetailUseCase(this._chatListRepository);

  Future<Room> execute(String roomId) async {
    return await _chatListRepository.getChatRoomDetail(roomId);
  }
}
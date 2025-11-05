import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class GetChatRoomUseCase {
  final ChatRoomRepository _chatRoomRepository;

  GetChatRoomUseCase(this._chatRoomRepository);

  Future<List<Message>> execute(String roomId) {
    return _chatRoomRepository.getChatMessages(roomId);
  }
}
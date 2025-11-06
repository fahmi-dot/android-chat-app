import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class GetChatMessageUseCase {
  final ChatRoomRepository _chatRoomRepository;

  GetChatMessageUseCase(this._chatRoomRepository);

  Future<List<Message>> execute(String roomId, String userId) {
    return _chatRoomRepository.getChatMessages(roomId, userId);
  }
}
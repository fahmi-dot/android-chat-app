import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class GetRoomMessagesUseCase {
  final ChatRoomRepository _chatRoomRepository;

  GetRoomMessagesUseCase(this._chatRoomRepository);

  Future<List<Message>> execute(String roomId, String userId) async {
    return await _chatRoomRepository.getRoomMessages(roomId, userId);
  }
}
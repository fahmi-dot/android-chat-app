import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class MarkAsReadUseCase {
  final ChatRoomRepository _chatRoomRepository;

  MarkAsReadUseCase(this._chatRoomRepository);

  Future<void> execute(String roomId) async {
    await _chatRoomRepository.markAsRead(roomId);
  }
}
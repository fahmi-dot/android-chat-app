import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetChatRoomsUseCase {
  final ChatListRepository _chatListRepository;
  final Ref ref;

  GetChatRoomsUseCase(this._chatListRepository, this.ref);

  Future<List<Room>> execute() async {
    return await _chatListRepository.getChatRooms();
  }
}
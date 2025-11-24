import 'package:android_chat_app/features/chat/data/datasources/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  final ChatListRemoteDataSource chatListRemoteDataSource;

  ChatListRepositoryImpl({required this.chatListRemoteDataSource});

  @override
  Future<List<Room>> getChatRooms() async {
    final roomModels = await chatListRemoteDataSource.getChatRooms();

    return roomModels.map((user) => user.toEntity()).toList();
  }
  
  @override
  Future<Room> getChatRoomDetail(String roomId) async {
    final roomModel = await chatListRemoteDataSource.getChatRoomDetail(roomId);

    return roomModel.toEntity();
  }
  
  @override
  Future<void> markAsRead(String roomId) async {
    return await chatListRemoteDataSource.markAsRead(roomId);
  }
}
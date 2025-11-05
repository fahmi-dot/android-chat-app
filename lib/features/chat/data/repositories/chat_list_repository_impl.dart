import 'package:android_chat_app/features/chat/data/datasources/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  final ChatListRemoteDataSource chatListRemoteDataSource;

  ChatListRepositoryImpl({required this.chatListRemoteDataSource});

  @override
  Future<List<Room>> getChatRoomList() async {
    return await chatListRemoteDataSource.getChatRoomList();
  }
  
  @override
  Future<Room> getChatRoomDetail(String roomId) async {
    return await chatListRemoteDataSource.getChatRoomDetail(roomId);
  }
  
  
}
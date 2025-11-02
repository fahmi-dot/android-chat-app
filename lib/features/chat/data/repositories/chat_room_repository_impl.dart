import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRoomRemoteDataSource chatRoomRemoteDataSource;

  ChatRoomRepositoryImpl({required this.chatRoomRemoteDataSource});
  
  @override
  Future<List<ChatRoom>> getMessages(String roomId) async {
    return await chatRoomRemoteDataSource.getMessages(roomId);
  }
  
}
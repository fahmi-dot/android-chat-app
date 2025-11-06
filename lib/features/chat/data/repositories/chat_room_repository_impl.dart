import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRoomRemoteDataSource chatRoomRemoteDataSource;

  ChatRoomRepositoryImpl({required this.chatRoomRemoteDataSource});
  
  @override
  Future<List<Message>> getChatMessages(String roomId, String userId) async {
    return await chatRoomRemoteDataSource.getChatMessages(roomId, userId);
  }
  
}
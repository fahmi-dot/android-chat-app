import 'package:android_chat_app/features/chat/data/datasources/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  final ChatListRemoteDataSource chatListRemoteDataSource;

  ChatListRepositoryImpl({required this.chatListRemoteDataSource});

  @override
  Future<List<ChatList>> list() async {
    return await chatListRemoteDataSource.list();
  }
  
}
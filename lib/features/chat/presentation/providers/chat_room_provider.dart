import 'dart:async';

import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/models/message_model.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomRemoteDataSourceProvider = Provider<ChatRoomRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return ChatRoomRemoteDataSourceImpl(api: api);
});

final chatRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final datasource = ref.read(chatRoomRemoteDataSourceProvider);
  return ChatRoomRepositoryImpl(chatRoomRemoteDataSource: datasource);
});

final getChatMessageUseCaseProvider = Provider<GetChatMessageUseCase>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return GetChatMessageUseCase(repository);
});

final chatRoomProvider = AsyncNotifierProvider.family<ChatRoomNotifier, List<Message>?, String>(
  ChatRoomNotifier.new
);

class ChatRoomNotifier extends AsyncNotifier<List<Message>?> {
  late final GetChatMessageUseCase _getChatRoomUseCase;
  late final String userId;
  final String roomId;

  ChatRoomNotifier(this.roomId);

  @override
  FutureOr<List<Message>?> build() async {
    _getChatRoomUseCase = ref.read(getChatMessageUseCaseProvider);

    final auth = await ref.read(authProvider.future);
    userId = auth!.id;
    
    final messages = await _getChatRoomUseCase.execute(roomId, userId);
    
    ref.read(wsClientProvider).subscribeToRoom(roomId);
    
    ref.listen<AsyncValue<dynamic>>(
      wsMessageStreamProvider,
      (previous, next) {
        next.whenData((data) {
          final type = data['type'];
          final messageRoomId = data['roomId'];
          
          if (type == 'new_message' && messageRoomId == roomId) {
            _handleNewMessage(data);
          }
        });
      },
    );

    return messages;
  }

  void _handleNewMessage(dynamic data) {
    try {
      final newMessage = MessageModel.fromJson(data, userId);
      
      state.whenData((messages) {
        final exists = messages!.any((message) => message.id == newMessage.id);

        if (!exists) {
          state = AsyncData([newMessage, ...messages]);
        }
      });
    } catch (e) {
      print('Failed to handle new message: $e');
    }
  }

  Future<bool> sendMessage(String message, String? receiver) async {
    try {
      final ws = ref.read(wsClientProvider);
      ws.sendMessage(roomId: roomId, content: message, receiver: receiver);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }
  
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final messages = await _getChatRoomUseCase.execute(roomId, userId);
      state = AsyncData(messages);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
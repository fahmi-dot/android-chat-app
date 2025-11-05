import 'dart:async';

import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
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
  final String roomId;

  ChatRoomNotifier(this.roomId);

  @override
  FutureOr<List<Message>?> build() async {
    _getChatRoomUseCase = ref.read(getChatMessageUseCaseProvider);
    
    final messages = await _getChatRoomUseCase.execute(roomId);
    
    ref.read(wsClientProvider).subscribeToRoom(roomId);
    
    ref.listen<AsyncValue<dynamic>>(
      wsMessageStreamProvider,
      (previous, next) {
        next.whenData((data) {
          final type = data['type'] as String?;
          final messageRoomId = data['roomId'] as String?;
          
          if (type == 'message' && messageRoomId == roomId) {
            // _handleNewMessage(data);
          }
        });
      },
    );

    return messages;
  }

  Future<void> getMessages() async {
    state = const AsyncLoading();
    try {
      final chatList = await _getChatRoomUseCase.execute(roomId);
      state = AsyncData(chatList);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  // void _handleNewMessage(dynamic data) {
  //   try {
  //     final authState = ref.read(authProvider);
  //     final currentUsername = authState.value?.username ?? '';
      
  //     final newMessage = ChatRoom.fromJson(data, currentUsername);
      
  //     state.whenData((messages) {
  //       final exists = messages!.any((msg) => msg.id == newMessage.id);
  //       if (!exists) {
  //         state = AsyncData([newMessage, ...messages]);
  //       }
  //     });
  //   } catch (e) {
  //     print('Terjadi kesalahan: $e');
  //   }
  // }
  
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final messages = await _getChatRoomUseCase.execute(roomId);
      state = AsyncData(messages);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
  
  void addOptimisticMessage(Message message) {
    state.whenData((messages) {
      state = AsyncData([message, ...messages!]);
    });
  }
}